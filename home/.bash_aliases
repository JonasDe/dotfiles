## Wrapper Aliases
alias pg="ps aux | grep"
alias s!="sudo !!"
alias ll="ls -alF"
alias tmux="tmux -2"
alias l="ls -la"
alias unziptar="tar -xf"
alias t="tmux"
alias sa="source $HOME/.bash_aliases"

# Safety
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"

# Utility functions
alias sagi="sudo apt-get install"
alias update="sudo apt-get update"

## File Edit & Source
alias eTODO="vim $HOME/.TODO/README.md"
alias ei3="vim $HOME/dotfiles/i3wm-themer/defaults/i3.template"
alias epo="vim $HOME/dotfiles/i3wm-themer/defaults/polybar.template"
alias ei3s="vim $HOME/.i3status.conf"
alias exr="vim $HOME/.Xresources"
alias ez="vim $HOME/.zshrc"
alias elz="vim $HOME/.local/.zshrc"
alias eh="vim $HOME/.bash_history"
alias fh="vim $HOME/.config/fish/fish_history"
alias sb="source $HOME/.bashrc"
alias slb="source $HOME/.local/.bashrc"
alias eb="vim $HOME/.bashrc"
alias elb="vim $HOME/.local/.bashrc"
alias sv="source $HOME/.vimrc"
alias ev="vim $HOME/.vimrc"
alias elv="vim $HOME/.local/vimrc"
alias et="vim $HOME/.tmux.conf"
alias ete="vim $HOME/.tmux.conf.extended"
alias sf="source $HOME/.config/fish/config.fish"
alias ef="vim $HOME/.config/fish/config.fish"
alias ea="vim $HOME/.bash_aliases"
alias elba="vim $HOME/.local/.bash_aliases"
alias sba="source $HOME/.bash_aliases"
alias ebf="vim $HOME/.bash_functions"
alias sbf="source $HOME/.bash_functions"
alias elbf="vim $HOME/.local/.bash_functions"
alias slbf="source $HOME/.local/.bash_functions"
alias sz="source $HOME/.zshrc"
alias cdf="cd $HOME/.config/fish/"
alias ei="vim $HOME/dotfiles/install.sh"
alias ep="vim $HOME/.profile"

## Quick Navigation
alias cdff="cd $HOME/.config/fish/functions"
alias dotf="cd $HOME/dotfiles"
alias dev="cd $HOME/dev"
alias cdvcfg="cd $HOME/.vim/config/"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

## Git
alias gs="git status"
alias gca="git commit --amend"
alias ga="git add"
alias gpush="git push"
alias gba="git branch -avv"
alias gpull="git pull"
alias gd="git diff"
alias gl="git log"

## Appended aliases 
# anything generated with mkalias will arrive here
alias efh="vim $HOME/.local/share/fish/fish_history"
alias fhistory="vim $HOME/.local/share/fish/fish_history"
alias githelp="cat $HOME/.help/githelp"
alias clip="xclip -selection c"
alias clswp="rm -r $HOME/.vim/tmp/swap/*"

# alias DISABLE_CAPS="python -c \"from ctypes import *; X11 = cdll.LoadLibrary("libX11.so.6"); display = X11.XOpenDisplay(None); X11.XkbLockModifiers(display, c_uint(0x0100), c_uint(2), c_uint(0)); X11.XCloseDisplay(display)\""
alias us="setxkbmap us -variant colemak"
alias logout="gnome-session-quit"
alias se="setxkbmap se"
alias elf="vim $HOME/.local/config.fish"
alias rwp="feh --bg-fill --randomize $HOME/.wallpapers/* &"
alias einst="vim $HOME/dotfiles/install.sh"
alias ekeymaps="vim $HOME/dev/qmk_firmware/keyboards/minidox/keymaps/jonasdedustycmk/keymap.c"
alias sshot="maim -s | xclip -selection clipboard -t image/png"
alias chrome="chromium --disable-gpu"

alias themer="cd $HOME/dotfiles/i3wm-themer"
alias ash="adb shell"
alias svenv="source ./env/bin/activate"
alias cvenv="virtualenv env"
alias me="maui input key enter"
alias mit="maui input text"
alias bugclean="rm -rf $HOME/Downloads/bug*"
alias mi="maui input text"
alias enotes="vim $HOME/.notes.org"
alias downloads="cd $HOME/Downloads"
alias enotes="emacs $HOME/dotfiles/TODO/.notes.org"
alias gp="git push"
alias slba="source $HOME/.local/.bash_aliases"
alias gfa="git fetch --all"
alias ela="vim $HOME/.local/.bash_aliases"
alias sla="source $HOME/.local/.bash_aliases"
alias fda="fd -IH"
alias estar="vim $HOME/dotfiles/config/starship.toml"
alias lzd="lazydocker"
alias hs="hg status"
alias tls='tmux list-session'
alias q='nq'
alias epa='vim /Users/jdanebjer/.private/.bash_aliases'
alias spa='source /Users/jdanebjer/.private/.bash_aliases'
alias cl='clear'
alias ga.='git add .'
alias epbf="vim $HOME/.private/.bash_functions"
alias spbf="source $HOME/.private/.bash_functions"
alias hu='hg-sl-up'
alias c='clear'
alias lc='adb logcat -c'
alias gitlintamend='ga . && git commit --amend --no-edit'
alias fb='z fba'
alias lres='hg resolve -l'
alias dot="cd $HOME/dotfiles"
