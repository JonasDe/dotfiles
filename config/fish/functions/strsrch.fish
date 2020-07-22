function strsrch -a dir pattern
    grep -rnw $dir -e "$pattern"
end

