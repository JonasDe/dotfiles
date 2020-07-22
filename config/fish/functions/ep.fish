function ep
    set prof (grep 'DOTFILES_PROFILE=' ~/.local.vars | cut -d\= -f2)
    vim $prof
end

