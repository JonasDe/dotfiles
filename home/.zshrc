HISTFILE=~/.bash_history
HISTSIZE=10000
SAVEHIST=10000
export CLICOLOR=1
source ~/.shell.common
setopt appendhistory
setopt share_history
setopt HIST_IGNORE_DUPS
setopt MENU_COMPLETE
bindkey -v
bindkey -s jk '\e'

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

turbo_init(){
    zinit ice wait'!0' 
    zinit load $1
}
source "$HOME/.zinit/bin/zinit.zsh"

# Jump around
turbo_init rupa/z

# Fuzzyfind search commandline
turbo_init junegunn/fzf

#zinit load zsh-users/zsh-syntax-highlighting
#turbo_init zsh-users/zsh-autosuggestions
turbo_init zsh-users/zsh-completions

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
    light-mode b4b4r07/zsh-vimode-visual 
    #light-mode  rupa/z \
    #light-mode  junegunn/fzf \

### Vim enhancement on cli
#turbo_init turbo_init supercrabtree/k
### Can manage local plugins
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#setopt prompt_subst # Make sure prompt is able to be generated properly.
## This can be slow.
## zplug "caiogondim/bullet-train.zsh", use:bullet-train.zsh-theme, defer:3 #
## Load theme file
## Then, source plugins and add commands to $PATH
#zstyle ':completion:*:default' list-colors \
  #"di=1;36" "ln=35" "so=32" "pi=33" "ex=31" "bd=34;46" "cd=34;43" \
  #"su=30;41" "sg=30;46" "tw=30;42" "ow=30;43"
zstyle ':completion:*' list-colors ''zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
#export LS_COLORS="di=31;41:ln=31;41:so=31;41:pi=31;41:ex=31;41:bd=31;41:cd=31;41:su=31;41:sg=31;41:tw=31;41:ow=31;41:"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#Jk,wzstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}
run-fzf() fzf
zle -N run-fzf
bindkey '^P' run-fzf
bindkey '^F' autosuggest-accept

zmodload zsh/complist
bindkey '^[[Z' reverse-menu-complete

# Overrides aliases for common commands
file=$HOME/.override_aliases
if [ -f $file ]; then
    while read -r line
    do
        # Skip comments
        [[ "$line" = \#* ]] && continue

        A="$(cut -d'=' -f1 <<<"$line")"
        B="$(cut -d'=' -f2 <<<"$line")"
        # Only make alias if other program exists
        [[ $(command -v $B) ]] && continue
        alias $A="$B"
    done < "$file"
fi
#
## The next line updates PATH for the Google Cloud SDK.
#if [ -f '$HOME/Downloads/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/Downloads/gcloud/google-cloud-sdk/path.zsh.inc'; fi
#if [ -f '$HOME/Downloads/gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/Downloads/gcloud/google-cloud-sdk/completion.zsh.inc'; fi
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#

### Added by Zinit's installer
#(( ${+_comps} )) && _comps[zinit]=_zinit
#compinit
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
#autoload -Uz compinit
#if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
#  compinit
#else
#  compinit -C
#fi
#zinit cdreplay -q
autoload -Uz compinit
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files


[ -f ~/.local/.zshrc ] && source ~/.local/.zshrc

[[ $(command -v starship) ]] && eval "$(starship init zsh)"
# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/tools/bin:${ANDROID_SDK}/platform-tools
