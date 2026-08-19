function _heat_volume
    set -l value $argv[1]

    if test $value -lt 41
        echo (set_color 7DF9FF)"$value % "(set_color normal)"🔈"
        return 0
    else if test $value -gt 40; and test $value -le 76
        echo (set_color FFA500)"$value % "(set_color normal)"🔉"
        return 0
    else
        echo (set_color E60000)"$value % "(set_color normal)"🔊"
        return 0
    end
end
