#!/usr/bin/env bash

DATE=$(date '+%Y%m%d%H%M%S')
DOTFILES_ROOT=$(pwd)
CONFIG_HOME="$HOME/.config"
LOCAL_SHARE="$HOME/.local/share"
EMACS_PRIVATE="$HOME/.emacs.d/private"
BACKUP_ROOT="$HOME/.dotfiles.backup-$DATE"
# Do not glob on useless files, and include dotfiles in glob
GLOBIGNORE=".:.."
shopt -s nullglob

# Fancy colors
blue='\e[1;34m'
red='\e[1;31m'
yellow='\e[1;33m'
green='\e[1;32m'
white='\e[0;37m'

# These suffixes are used for conditional operations on certain files
OFFLINEFILE=.offlineonly
COREFILE=.coreonly
SCPALLOWFILE=.scpallow

SYMLINK_MAP=("home,$HOME" "config,$CONFIG_HOME" "share,$LOCAL_SHARE" "hooks,$DOTFILES_ROOT/.git/hooks" "emacs-private,$EMACS_PRIVATE" "dev,$HOME/dev")

### ---- DISTRO SPECIFIC  ----
# To add a new distro, follow the numbered guide
# 1. Add new distro here
MAC=Darwin
UBUNTU=ubuntu
ARCH=arch
FEDORA=fedora
# 2. Add distro variable to this list
SUPPORTED_DISTROS="$MAC $UBUNTU $ARCH $FEDORA"

# 3. Add your OS installation function, accepting variable arguments
ubuntu_install() {
  sudo apt-get install -y $@ 
}
fedora_install() {
  dnf install $@
}
arch_install() {
  for var in "$@"; do
    pacman -Syy $var || pacaur -S $var || _aur_from_source $var || yaourt $var
  done
}
mac_install() {
  brew install $@ || brew cask install $@
}

# Check dynamically what OS is running
if [[ "$(uname -r)" == *"$ARCH"* ]]; then
  OS=$ARCH
  OS_INSTALL=arch_install
  OS_IGNORE=.archignore
elif [[ "$(uname)" == "$MAC" ]]; then
  # Mac is has a different syntax for specifying commandline colors
  blue='\033[1;34m'
  red='\033[1;31m'
  yellow='\033[1;33m'
  green='\033[1;32m'
  white='\033[0;37m'
  OS=$MAC
  OS_INSTALL=mac_install
  OS_IGNORE=.macignore
elif [[ "$(cat /etc/lsb-release)" == *"$UBUNTU"* ]]; then
  OS=$UBUNTU
  OS_INSTALL=ubuntu_install
  OS_IGNORE=.ubuntignore
elif [[ "$(uname -r)" == *"$FEDORA"* ]]; then
  OS=$FEDORA
  OS_INSTALL=fedora_install
  OS_IGNORE=.fedoraignore
else
  #Assume Ubuntu compatibility
  OS=$UBUNTU
  OS_INSTALL=ubuntu_install
fi
# 4. Add a new case which matches against your distro
# and assign the OS, OS_INSTALL, and OS_IGNORE variables
# accordingly

### ---- HELPER FUNCTIONS  ----
contains() {
  # Check if second argument in first argument. Expect first argument
  # to be a space-delimited 'list' of strings such as "A B C D"
  [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && echo 0 || echo 1
}

_aur_from_source() {
  if [[ ! -f /tmp/$1 ]]; then
    git clone https://aur.archlinux.org/$1.git /tmp/$1
  fi
  cd /tmp/$1 && makepkg -si
}
# TODO: Make dynamic
is_offline() {
  $(echo $1 | grep -q "$OFFLINE_SUFFIX")
  return $?
}
is_in_controlfile() { 
    local FILE=$1
    local CONTROL_FILE=$2
  if [[ -f $CONTROL_FILE ]];
  then 
        CONTROL=$(cat $CONTROL_FILE | awk '{print}' ORS=" "); 
  else
        return 1
  fi
  if [[ $(contains "$CONTROL" $FILE) == 0 ]]; then
    return 0
  fi
  return 1
}
  #F=$(echo $1 | sed "s/\(.*\)$OFFLINE_SUFFIX/\1/")
  #F=$(echo $F | sed "s/\(.*\)$CORE_SUFFIX/\1/")
trim_exc() {
  LAST_CHAR="${FILE: -1}"
  if [[ $LAST_CHAR == "!" ]]; then
    NEW_NAME=$(echo $FILE | sed 's/.$//')
  else
    NEW_NAME=$FILE
  fi
  echo $NEW_NAME
}
install_with() {
  install_command=$1
  shift
  shifts=0
  OS_DETECTED=false
  #TODO: Reuse logic in install_as
  for ARG in "$@"; do
    if [[ $(contains "$SUPPORTED_DISTROS" "$ARG") == "0" ]]; then
      ((shifts++))
      if [[ $ARG == $OS ]]; then
        OS_DETECTED=true
      fi
      continue
    else
      break
    fi
  done
  if [[ $OS_DETECTED != true ]]; then
    echo "'$@' doesn't contain '$OS', skipping."
    return
  fi
  for i in $(seq 1 $shifts); do
    shift
  done
  $install_command install "$@"
}
install_as() {
  # This function installs arguments passed after the supported OSes
  # using OS-specific installation.
  # E.g. 'install_as $ARCH $MAC vim'
  # Will install vim on MAC and ARCH distributions using the
  # OS-specific installation function.
  shifts=0
  OS_DETECTED=false
  for ARG in "$@"; do
    if [[ $(contains "$SUPPORTED_DISTROS" "$ARG") == "0" ]]; then
      ((shifts++))
      if [[ $ARG == $OS ]]; then
        OS_DETECTED=true
      fi
      continue
    else
      break
    fi
  done
  if [[ $OS_DETECTED != true ]]; then
    echo "'$@' doesn't contain '$OS', skipping."
    return
  fi
  for i in $(seq 1 $shifts); do
    shift
  done

  echo -e "Installing >> ${green} $@ ${white}: "
  $OS_INSTALL "$@"
}

# Print usage message.
usage() {
  local program_name
  program_name=${0##*/}
  cat <<EOF
Usage: $program_name [-option]

Options:
    --help                   Print this message
    -i                       Install all packages
    -l                       Link all dotfiles 
    -c                       Enables the 'core' flag, reducing the set of files operated on to those in `.coreonly`.
    -o                       Enables the 'offline' flag, reducing the set of files operated on to those in `.offlineonly`.
    -u                       Update submodules
    -d <user> <host> <port>  Deploy whole dotfiles repo on remote host and link.
    -s <user> <host> <port>  Scp files in .scpallow to remote host
    -b                       Avoid backing up
    -r <backup_folder>       Restore old config
EOF
}

### ---- INSTALLATION MODULES  ----
#   define your own functions here and add to the SECTIONS variable
#   to add them for installation.
i3wm_themer() {
  git submodule update --init --recursive -- ./i3wm-themer
  if [[ "$OS" == $ARCH ]]; then ./i3wm-themer/install_arch.sh; fi
  if [[ "$OS" == $UBUNTU ]]; then ./i3wm-themer/install_ubuntu.sh; fi
  install_as $ARCH papirus-icon-theme
  cargo install i3wsr
}
TODO() {
  TODO_FILE=.notes.org
  git submodule update --recursive --remote
  ln -s $DOTFILES_ROOT/TODO/$TODO_FILE $HOME/$TODO_FILE
}
_fzf(){
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}
fish_install() {
  curl -L https://get.oh-my.fish | fish
  fish -c "omf install https://github.com/jethrokuan/fzf"
  fish -c "omf install z"
}
_tmux() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}
_diff-so-fancy(){
# tired of "Unable to locate package diff-so-fancy ?"
# choose a folder that is in your PATH or create a new one
    mkdir -p ~bin
    # add ~/bin to your PATH (.bashrc or .zshrc)
    cd ~/bin
    git clone https://github.com/so-fancy/diff-so-fancy diffsofancy
    chmod +x diffsofancy/diff-so-fancy
    ln -s ~/bin/diffsofancy/diff-so-fancy ~/bin/diff-so-fancy

}
latest(){
    curl -s https://api.github.com/repos/$1/releases/latest \
    | grep "browser_download_url.*deb" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
}
_fd(){
    install_as $UBUNTU $FEDORE fd-find
    install_as $ARCH $MAC fd
}
cargo_install(){
    [[ $(command -v cargo) ]] && cargo install $1
}

cli_utils() {
  install_as $ARCH $FEDORA $UBUNTU $MAC htop 
  install_as $ARCH $FEDORA $UBUNTU $MAC neovim 
  install_as $ARCH $FEDORA $UBUNTU $MAC ripgrep 
  install_as $ARCH $FEDORA $UBUNTU $MAC xclip 
  install_as $ARCH $FEDORA $UBUNTU $MAC tmux 
  install_as $ARCH $FEDORA $UBUNTU $MAC rxvt-unicode 
  install_as $ARCH $FEDORA $UBUNTU $MAC bat 
  install_as $ARCH $FEDORA $UBUNTU $MAC tldr 
  install_as $ARCH $FEDORA $UBUNTU $MAC colordiff 
  install_as $ARCH $FEDORA $UBUNTU $MAC glances  
  install_as $ARCH $FEDORA $UBUNTU $MAC fasd 
  install_as $ARCH $FEDORA $UBUNTU $MAC zsh 
  _fzf 
  _diff-so-fancy
  _fd
  cargo_install exa
  cargo_install bat
  install_as $ARCH $FEDORA $UBUNTU jq 
  install_as $ARCH $FEDORA $UBUNTU expac 
  install_as $ARCH $FEDORA $UBUNTU rofi 
  install_as $ARCH $FEDORA $UBUNTU guake 
  install_as $ARCH $FEDORA $UBUNTU rofi-emoji 
  install_as $ARCH $FEDORA $UBUNTU autocutsel
  install_as $ARCH gvim
  install_as $MAC starship 
  install_as $MAC lazydocker
  if [[ $OS == $ARCH ]]; then
    git clone https://aur.archlinux.org/lazydocker.git /tmp/lazydocker
    $(cd /tmp/lazydocker && makepkg --install)
  fi

  FONTNAME="Fira Code Regular"
  FONT="Fira%20Code%20Regular"
  FONTPATH="FiraCode/Regular"
  git clone --depth=1 https://github.com/powerline/fonts.git /tmp/fonts
  $(cd /tmp/fonts && ./install.sh)
  rm -rf /tmp/fonts
  if [[ $OS == $ARCH ]]; then
    install_with snap $ARCH starship
  else
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
  fi

}
_git() {
  install_as $ARCH $FEDORA $UBUNTU $MAC git diff-so-fancy
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
}
basics() {
  install_as $ARCH $FEDORA $UBUNTU $MAC curl git zsh npm yarn
  _git
  install_as $ARCH pacaur yaourt auracle-git snapd chromium
  if [[ $OS == $ARCH ]]; then
    install_as $ARCH snapd
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
    sudo systemctl start --now snapd.socket
    sudo snap install dmidecode-tool
  fi
  curl https://sh.rustup.rs -sSf | sh
  source $HOME/.cargo/env
}
emacs() {
  install_as $ARCH $FEDORA $UBUNTU $MAC git emacs ripgrep clang tar fd
  git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
  ~/.emacs.d/bin/doom install
  if [[ $OS == $MAC ]]; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus pngpaste
    ln -s /usr/local/Cellar/emacs-plus/*/Emacs.app/ /Applications/
  fi
}
audio() {
  install_as $ARCH alsa-utils sof-firmware
  if [[ $OS == $ARCH ]]; then
    sudo echo "load-module module-alsa-sink device=hw:0,0 channels=4" >>/etc/pulse/default.pa
    sudo echo "load-module module-alsa-source device=hw:0,6 channels=4" >>/etc/pulse/default.pa
  fi
  # FIXME change this below statement to relevant statement for the hardware at hand.
  # This works for Lenovo Thinkpad Carbon X1 gen 7
  #sudo echo "set-card-profile 0 HiFi" >> /etc/pulse/default.pa
}

### ---- OPERATIONS ----
backup() {
  local DST=$BACKUP_ROOT/$1
  local SRC=$2
  echo -e "${yellow}Backing up $SRC -> $DST"
  mkdir -p $DST
  cd "$DST" || exit
  for FILE in $DOTFILES_ROOT/$1/*; do
    FILE=$(basename $FILE)
    [ -f $DST/$FILE ] && cp -a $SRC/$FILE $DST/$FILE
  done
  echo -e "${green}Backup of $SRC done!"
}
link() {
  local SRC=$DOTFILES_ROOT/$1
  local DST=$2
  echo -e "${yellow}Linking files in $SRC -> $DST"
  validate $SRC
  echo "${VALID_FILES[@]}"
  for FILE in "${VALID_FILES[@]}"; do
    FILE=$(basename $FILE)
    env rm -rf $DST/$FILE
    mkdir -p $DST && ln -fs "$SRC/$FILE" "$DST/$DST_NAME"
  done
  echo -e "${green}Linking of $SRC done!"
}
restore() {
  local SRC=$RESTORE_ROOT/$1
  local DST=$2
  mkdir -p $DST
  cd "$DST" || exit
  echo -e "${yellow}Restoring $SRC -> $DST"
  for FILE in $SRC/*; do
    FILE=$(basename $FILE)
    env cp -rfa "$SRC/$FILE" "$DST/$FILE"
  done
  echo -e "${green}Restore of $SRC done!"
}

install_packages() {
  echo "Detected OS: $OS"
  SECTIONS=(basics cli_utils emacs fish_install TODO)
  if [[ $OS != $MAC ]]; then SECTIONS+=(i3wm_themer); fi
  if [[ $OS == $ARCH ]]; then SECTIONS+=(audio); fi

  for section in "${SECTIONS[@]}"; do
    echo -ne "Would you like to setup ${green} $section ${white}? [${green}y${white}/${red}N${white}]: "
    read prompt
    if [[ "$prompt" == "y" || "$prompt" == "yes" ]]; then
      $section
      cd $DOTFILES_ROOT
    fi
  done

}
populate_temp_for_scp() {
  local SRC=$DOTFILES_ROOT/$1
  local TEMP_DST=$TEMP/$1
  mkdir -p $TEMP_DST
  validate $SRC
  for FILE in "${VALID_FILES[@]}";do
        cp -r $SRC/$FILE $TEMP_DST
  done
}
secure_shell_deploy() {
  local USER=$1
  local HOST=$2
  local PORT=$3
  dotfiles_url=$(git remote show origin | head -n 2 | tail -n 1 | awk '{print $3;}')
  if [ -z $(echo $prefix | grep https) ]; then
    remote_host=$(echo $dotfiles_url | cut -d ':' -f 1 | cut -d '@' -f 2)
    repo=$(echo $dotfiles_url | cut -d ':' -f 2)
    dotfiles_url=https://$remote_host/$repo
  fi
  echo $dotfiles_url
  #ssh -t $@ <<ENDSSH
  #git clone $dotfiles_url && cd dotfiles && ./install.sh -l
  #ENDSSH
  echo ssh -p $PORT -t $USER@$HOST "git clone $dotfiles_url && cd dotfiles && ./install.sh -l && /bin/sh"
  ssh -t $USER@$HOST -p $PORT "git clone $dotfiles_url && cd dotfiles && ./install.sh -l && /bin/sh"
}
validate_in_controlfile(){
        is_in_controlfile $1 $2 
        if [ $? -eq 0 ]; then
            [[ $ECHO_VALIDATION_ONLY ]] && echo "$1 $2"
        else
            [[ -z $ECHO_VALIDATION_ONLY ]] && continue
        fi
}
validate(){
  # Fills the array `VALID_FILES`  with the valid files according
  # to the values set inside the controlfiles.
  # If the `ECHO_VALIDATION_ONLY` variable is set, will print values that
  # pass controlfile check.
  VALID_FILES=()
  local SRC=$1
  for FILE in $SRC/*; do
    FILE=$(basename $FILE)
    if [[ $CORE_ONLY ]]; then
        validate_in_controlfile $FILE $SRC/$COREFILE
    fi
    if [[ $OFFLINE_ONLY ]]; then
        validate_in_controlfile $FILE $SRC/$OFFLINEFILE
    fi
    is_in_controlfile $FILE $SRC/$OS_IGNORE
    [ $? -eq 0 ] && continue

    if [[ $SCPCOPY ]]; then
        validate_in_controlfile $FILE $SRC/$SCPALLOWFILE
    fi
    VALID_FILES+=($FILE)
  done
}

main() {
  commands=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
    '' | -h | --help)
      usage
      exit 0
      ;;
    -u)
      git submodule update --recursive --remote
      echo "${green} Submodules initalized and updated!"
      exit
      ;;
    -i)
      install_packages
      shift
      ;;
    -l)
      commands+=("link")
      shift
      ;;
    -c)
      CORE_ONLY=true
      shift
      ;;
    -s)
      shift
      SCPCOPY=true
      local USER=$1
      local HOST=$2
      local PORT="${3:-22}"
      TEMP=$(mktemp -d)/dotfiles
      mkdir -p $TEMP
      run_command_over_symlink_map populate_temp_for_scp
      cp $DOTFILES_ROOT/install.sh $TEMP
      scp -P $PORT -r $TEMP "$USER@$HOST:~"
      ssh -t $USER@$HOST -p $PORT "cd ~/dotfiles && ./install.sh -l && /bin/bash"
      rm -rf $TEMP
      exit 0
      ;;
    -d)
      shift
      local USER=$1
      local HOST=$2
      local PORT="${3:-22}"
      secure_shell_deploy $USER $HOST $PORT
      # "This operation cannot be chained"
      exit 0
      ;;
    -o)
      OFFLINE_ONLY=true
      shift
      ;;
    -v)
      OFFLINE_ONLY=true
      CORE_ONLY=true
      SCPCOPY=true 
      ECHO_VALIDATION_ONLY=true
      run_command_over_symlink_map validate
      exit
      ;;
    -b)
      backup=false
      shift
      ;;
    -r)
      if [ -z "$2" ]; then
        echo "You must include a backup folder"
        exit
      fi
      # Remove trailing slash
      RESTORE_ROOT=${2%/}
      commands+=("restore")
      shift
      shift
      ;;
    *)
      echo "Command not found" >&2
      exit 1
      ;;
    esac
  done
  if [ "$backup" != "false" ]; then
    echo -e "The backup folder will be ${red} $BACKUP_ROOT"
    echo -e "${white}Please be aware that backup folders are ${red}NOT ${white}automatically removed to provide redundancy. ${red}Remember to clean them up."
    commands=("backup" "${commands[@]}")
  fi

  # Run all collected commands over items in SYMLINK_MAP
  for i in "${!commands[@]}"; do
    OLDIFS=$IFS
    IFS=','
    for j in "${SYMLINK_MAP[@]}"; do
      set -- $j
      IFS=$OLDIFS
      ${commands[$i]} $1 $2
      IFS=','
    done

    IFS=$OLDIFS
  done

}
run_command_over_symlink_map(){
    local COMMAND=$1
    shift
    local REMAINDER="$@"
    OLDIFS=$IFS
    IFS=','
    for j in "${SYMLINK_MAP[@]}"; do
      set -- $j
      IFS=$OLDIFS
      $COMMAND $1 $2 $REMAINDER
      IFS=','
    done
    IFS=$OLDIFS
}

main "$@"
