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
OFFLINEONLY=.offlineonly
COREONLY=.coreonly
SCPIGNORE=.scpignore

SYMLINK_MAP=("home,$HOME" "config,$CONFIG_HOME" "share,$LOCAL_SHARE" "hooks,$DOTFILES_ROOT/.git/hooks" "emacs-private,$EMACS_PRIVATE" "dev,$HOME/dev")

### ---- DISTRO SPECIFIC  ----
# To add anew distr, follow the numbered guide
# 1. Add new distro here
MAC=Darwin
UBUNTU=ubuntu
ARCH=arch
FEDORA=fedora
# 2. Add distro variable to this list
SUPPORTED_DISTROS="$MAC $UBUNTU $ARCH $FEDORA"

# 3. Add your OS installation function, accepting variable arguments
ubuntu_install() {
  apt-get install $@
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
elif [[ "$(uname -r)" == *"$UBUNTU"* ]]; then
  echo empty
  OS=$UBUNTU
  OS_INSTALL=ubuntu_install
  OS_IGNORE=.ubuntignore
elif [[ "$(uname -r)" == *"$FEDORA"* ]]; then
  OS=$FEDORA
  OS_INSTALL=fedora_install
  OS_IGNORE=.fedoraignore
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
is_scpignore() {
  return $(echo $1 | grep "$CORE_SUFFIX")
}
is_valid() {
    is_core $1
    if [ $CORE_ONLY && "$?" != "0" ];
    then
        return -1
    fi
    is_offline $1
    if [ $OFFLINE_ONLY && "$?" != "0" ];
    then
        return -1
    fi
    is_scpignore $1
    # Special case here. We want SCPIGNORE to ignore
    # files, thus marking them as not valid if this flag
    # is on and we find `__scpignore` in the name
    if [ $SCPIGNORE && "$?" == "0" ];
    then
        return -1
    fi
    return 0
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
    -c                       Enables the 'core' flag, reducing the set of files operated on to those with with '__core' in the filename.
                             dotfiles considered 'core']
    -u                       Update submodules
    -d <ssh_args>            Deploy dotfiles on remote host 
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
fish_install() {
  curl -L https://get.oh-my.fish | fish
  fish -c "omf install https://github.com/jethrokuan/fzf"
  fish -c "omf install z"
}
_tmux() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}
cli_utils() {
  install_as $ARCH $FEDORA $UBUNTU $MAC fd exa htop zsh neovim ripgrep xclip fzf tmux rxvt-unicode bat tldr colordiff glances diff-so-fancy
  install_as $ARCH $FEDORA $UBUNTU jq expac rofi guake rofi-emoji autocutsel
  install_as $ARCH gvim
  install_as $MAC starship lazydocker
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
  install_with snap $ARCH starship
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
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
  if [[ $OS == $MAC ]]; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus
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
  for FILE in ${FILES[@]}; do
    FILE=$(basename $FILE)
    continue
    if [[ $(contains $IGNORE $FILE) == 0 ]]; then
      echo skip $FILE
      continue
    fi
    LAST_CHAR="${FILE: -1}"

    if [[ $CORE_ONLY == "true" && $LAST_CHAR != "!" ]]; then
      continue
    fi
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
secure_shell_copy() {
  echo abc
}
secure_shell_deploy() {
  echo "ssh $@"
  dotfiles_url=$(git remote show origin | head -n 2 | tail -n 1 | awk '{print $3;}')
  if [ -z $(echo $prefix | grep https) ]; then
    host=$(echo $dotfiles_url | cut -d ':' -f 1 | cut -d '@' -f 2)
    repo=$(echo $dotfiles_url | cut -d ':' -f 2)
    dotfiles_url=https://$host/$repo
  fi
  #ssh -t $@ <<ENDSSH
  #git clone $dotfiles_url && cd dotfiles && ./install.sh -l
  #ENDSSH
  ssh -t $@ "git clone $dotfiles_url && cd dotfiles && ./install.sh -l && /bin/sh"
}
validate(){
  VALID_FILES=()
  local SRC=$1
  local DST=$2
  for FILE in $SRC/*; do
    FILE=$(basename $FILE)
    if [[ $CORE_ONLY ]]; then
        is_in_controlfile $FILE $SRC/$COREONLY
        [ $? -ne 0 ] && continue
    fi
    if [[ $OFFLINE_ONLY ]]; then
        is_in_controlfile $FILE $DST $SRC/$OFFLINEONLY
        [ $? -ne 0 ] && continue
    fi
    is_in_controlfile $FILE $DST $SRC/$OS_IGNORE
    [ $? -eq 0 ] && continue
    if [[ $SCPCOPY ]]; then
        is_in_controlfile $FILE $DST $SRC/$SCPIGNORE
        [ $? -ne 0 ] && continue
    fi

    VALID_FILES+=($FILE)
  done
  echo "${VALID_FILES[@]}"
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
      commands+=("secure_shell_copy")
      SCPCOPY=true
      shift
      ;;
    -d)
      shift
      secure_shell_deploy "$@"
      # "This operation cannot be chained"
      exit 0
      ;;
    -o)
      OFFLINE_ONLY=true
      shift
      ;;
    -v)
      commands+=("validate")
      shift
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
main "$@"
