# set -U fish_user_paths /usr/local/bin $fish_user_paths
if test -e $HOME/.local/bin
    set PATH $HOME/.local/bin $PATH
end
# Will override existing aliases if these programs exist
if test -e $HOME/.override_aliases
    while read -la line
        switch "$line"
            case "#*"
                # Do nothing
            case "*"
                set pair (string split "=" -- $line)
                if type -q $pair[2]
                    alias $pair[1]=$pair[2]
                end
        end
    end < $HOME/.override_aliases
end

for file in ~/.bash_aliases ~/.local/.bash_aliases ~/.layout
    if test -e ~/.bash_aliases
        source ~/.bash_aliases
    end
end
fish_user_key_bindings
fzf_key_bindings
