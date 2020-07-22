function mkalias --argument al cmd 
    echo "alias $al='$argv[2..-1]'" >> ~/.bash_aliases
    sf
end
