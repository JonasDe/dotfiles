function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
	if type -q fzf_key_bindings
		# Add fancy fzf keybindings if they exist
		fzf_key_bindings
        	bind -M $mode \cp fzf-history-widget
	end
    end
end
