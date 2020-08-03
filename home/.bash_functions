#!/bin/bash
function ghclone(){ git clone https://github.com/"$1" ;}
function loop(){ 
    count=$1
    shift
    for i in `seq $count`; do
        eval "$@"
    done ;
}
function glclone(){ git clone https://gitlab.com/"$1" ;}
function gitignore() { curl -L -s https://www.gitignore.io/api/\$@ ;}
function rmswap(){ rm ~/.vim/tmp/swap/"$1" ;}
function TODO(){ echo "* $@" >> $HOME/.notes.org ;}
mkalias(){ 
    name=$1
    shift
    echo "alias $name='$@'" >> ~/.bash_aliases
    source ~/.bash_aliases
}
mklalias(){ 
    name=$1
    shift
    echo "alias $name='$@'" >> ~/.local/.bash_aliases
    source ~/.local/.bash_aliases
}
mkpalias(){ 
    name=$1
    shift
    echo "alias $name='$@'" >> ~/.private/.bash_aliases
    source ~/.private/.bash_aliases
}
wm-refresh(){
    $(cd ~/dotfiles/i3wm-themer && python i3wm-themer.py --config defaults/config.yaml --install defaults/)
}
gc(){
    a="$@"
    echo $a
    git commit -m "$a"
}
gra(){
    cat ~/.private/.bash_aliases ~/.bash_aliases ~/.local/.bash_aliases ~/.bash_functions ~/.local/.bash_functions | grep -e "$@"
}
ta(){
    tmux attach -t $1
}
e(){
    emacs "$@" &
}


