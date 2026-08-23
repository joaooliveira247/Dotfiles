function firefox --description 'Run Firefox detached'
    if not sudo -v
        echo "Acess denied!"
        return 1
    end

    if contains -- "-d" $argv
        set -l args
        for val in $argv
            if test "$val" != "-d"
                set -a args $val
            end
        end

        command firefox $args &> /dev/null & disown
        return 0
    else
        command firefox $argv
        return 0
    end
end
