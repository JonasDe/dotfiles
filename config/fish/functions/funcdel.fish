function funcdel --argument fname
	rm ~/.config/fish/functions/$fname.fish
	rm ~/dotfiles/.functions.fish/$fname.fish
end
