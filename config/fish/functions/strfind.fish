function strfind -a pattern path
    grep -sRil "$path" $pattern
end

