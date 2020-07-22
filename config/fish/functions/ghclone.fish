function ghclone
    switch (count $argv)
        case 1
            git clone https://github.com/$argv[1]
        case 2
            git clone https://github.com/$argv[1] $argv[2]
    end
end
