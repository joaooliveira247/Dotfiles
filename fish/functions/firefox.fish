function firefox --description 'Executa Firefox detached'
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

        command firefox $args >/dev/null 2>&1 &

        disown (jobs -l -p | last) ^/dev/null

        commandline -f repaint
    else
        command firefox $argv
    end
end
