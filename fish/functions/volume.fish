function volume -d "set sys volume"

    set -l volume_prefix "🎧" (set_color FFEF00)"Volume:"(set_color normal)

    set currentVolume (amixer sget Master | string match -r '\d+%' | head -n 1 | string replace '%' '')

    if test (count $argv) -eq 0
        echo "$volume_prefix Current volume is: $(_heat_volume $currentVolume)"
        return 0
    end

    set -l help '🎧 Volume - Simple interface to set sys volume

Usage:
    volume [<command> | <option>]

Commands:
    set, -s <1-100>  Set sys volume to given value
    mute, -m         Mute sys volume
    unmute, -u       Unmute sys volume

Options:
    -h, --help      This help

Examples:
    volume          # show current volume (ex: "🎧 Volume: Current volume is: 50%)
    volume set 80   # set volume to 80%'

    switch $argv[1]
        case --help -h
            echo $help
            return 0
        case set -s
            set volume $argv[2]
            set min 1
            set max 100

            if string match -qr '^-?[0-9]+$' -- $volume; and test $volume -ge $min; and test $volume -le $max
                amixer -D pulse sset Master $volume% &> /dev/null
                echo "$volume_prefix Change volume to $(_heat_volume $volume)"
                return 0
            else
                echo "$volume_prefix $volume Invalid value. Please enter a integer number between 1 and 100."
                return 1
            end
        case mute -m
            amixer -D pulse sset Master mute
            echo "$volume_prefix Muted 🔇"
            return 0
        case unmute -u
            amixer -D pulse sset Master unmute
            echo "$volume_prefix Unmuted"
            return 0
        case '*'
            echo "$volume_prefix Invalid option"
            echo $help
            return 1
    end
end
