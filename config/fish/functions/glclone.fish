function glclone
    switch (count $argv)
        case 1
            git clone https://gitlab.com/$argv[1]
        case 2
            git clone https://gitlab.com/$argv[1] $argv[2]
    end
end
