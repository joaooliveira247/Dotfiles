function diffTime
    function to_seconds
        set -l parts (string split ':' $argv[1])
        set -l h $parts[1]
        set -l m $parts[2]
        set -l s $parts[3]

        math "$h * 3600 + $m * 60 + $s"
    end

    set -l help '⏱️ diffTime - Simple calculator between two times

Usage:
    diffTime [options] <t1> <t2>

Arguments:
    <t1>            Initial timestamp in HH:MM:SS HH:MM:SS
    <t2>            Final timestamp in HH:MM:SS HH:MM:SS

Options:
    -h, --help      This help

Examples:
    diffTime 08:00:00 10:30:15  # Returns 02:30:15'

    if string match -q -- "$argv[1]" "-h" "--help"
        echo "$help"
        return 1
    end

    if test (count $argv) -ne 2
        echo "$help"
        return 1
    end

    set -l sec1 (to_seconds $argv[1])
    set -l sec2 (to_seconds $argv[2])
    set -l diff (math "abs($sec1 - $sec2)")

    set -l h (math -s0 "$diff / 3600")
    set -l m (math -s0 "($diff % 3600) / 60")
    set -l s (math "$diff % 60")

    set_color FFEF00 --bold; printf "%02d:%02d:%02d\n" $h $m $s; set_color normal
end
