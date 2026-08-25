function radio -d "mpv webradio control"
    set -l radio_prefix "📻 "(set_color ff79c6)"Radio:"(set_color normal)
    set -l radio_title "RadioCLI"

    set -l help "📻 Radio - mpv webradio control
Usage:
    radio [<command> | <option>] [station/args]

Commands:
    on <station> [vol]  Turn on web radio [pop|mpb|br|lofi|master] (Default vol: 50%)
    off                 Stop the active web radio
    list                List all available stations
    switch              TODO
    volume              Show current volume level
    volume set <1-100>  Set playback volume level

Options:
    -h, --help          Show this help message

Examples:
    radio               # Display currently playing station (if active)
    radio list          # List all available stations
    radio on lofi 40    # Start playing Lo-Fi station at 40% volume
    radio volume        # Show current volume
    radio volume set 80 # Change volume to 80%
    radio off           # Stop radio playback
"

    # Define map_station to use jq to get radio station
    set -l map_station '{
        "pop": "https://live.hunter.fm/pop_stream?ag=mp3",
        "mpb": "https://live.hunter.fm/mpb_stream?ag=mp3",
        "br": "https://live.hunter.fm/hitsbrasil_stream?ag=mp3",
        "lofi": "https://live.hunter.fm/lofi_stream?ag=mp3",
        "master": "https://live.hunter.fm/master_stream?ag=mp3"
    }'

    set -l pids (pgrep -f $radio_title; or echo 0)
    set radio_status

    if test -n "$pids"
        set radio_status $pids[1]
    else
        set radio_status 0
    end


    set -l command $argv[1]

    # commands that can run with radio off (help/list/on)
    # commands that can run with radio on / off (help/list)
    # commands that can only run with radio on (volume/switch(not implement)/off)

    # if has no command or radio_status on
    if test -z "$command"
        if test "$radio_status" != 0
            set -l current_station (echo '{"command": ["get_property", "term-status-msg"]}' | nc -N -U /tmp/mpvsocket | jq '.data')
            set -l stream_url (echo $map_station | jq -r ".$current_station // empty")

            echo "$radio_prefix ▶️ Playing: $current_station station | Stream: $stream_url"

            return 1
        end
        echo "$help"
        return 1
    end

    # commands that can run with radio on / off (help/list)
    switch $command
        case "-h" "--help"
            echo "$help"
            return 1
        case "list"
            echo "$radio_prefix Available stations:"
            echo $map_station | jq -r 'keys[] | "  - " + .'
            return 0
    end

    # check if command is on and radio_status isn't on
    if test "$command" = "on"; and test "$radio_status" -eq 0
        set -l station $argv[2]
        set -l volume $argv[3]

        # Define o volume padrão para 50 caso não seja passado
        if test -z "$volume"
            set volume 50
        end

        # Mapeamento das URLs das estações
        set -l stream_url (echo $map_station | jq -r ".$station // empty")

        if test -z "$stream_url"
            echo "$radio_prefix Unknown or unspecified station. Use: radio on [pop|mpb|br|lofi|master] [volume]"
            return 0
        end

        # Se já houver uma rádio rodando, encerra antes de abrir a nova
        pkill -f "title=RadioCLI" 2>/dev/null

        # Inicia o mpv em background redirecionando as saídas para liberar o terminal
        echo "$radio_prefix ▶️ Starting radio $station (Volume: "(_heat_volume $volume)")..."
        fish -c "
                mpv --title='RadioCLI' --term-status-msg=$station --input-ipc-server=/tmp/mpvsocket --no-video --volume=$volume '$stream_url' &>/dev/null
                notify-send 'Radio CLI' '📻 Radio: $station was closed.' --icon=audio-speakers
                " &> /dev/null &
        disown
        return 1
    else if test "$command" = "on"; and test "$radio_status" != 0
        set -l current_station (echo '{"command": ["get_property", "term-status-msg"]}' | nc -N -U /tmp/mpvsocket | jq '.data')
        set -l stream_url (echo $map_station | jq -r ".$current_station // empty")

        echo "$radio_prefix ▶️ Playing: $current_station station | Stream: $stream_url"

        return 1
    end

    # check if has radio on to run those commands
    if test "$radio_status" = 0
        echo "$radio_prefix ⚠️ No active radio found."
        echo "$help"
        return 1
    end

    switch $command
        case "volume"
            set -l vol_command $argv[2]

            echo $vol_command
            if test "$vol_command" != "set"; or test -z $vol_command
                set -l current_volume $(echo '{"command": ["get_property", "volume"]}' | nc -N -U /tmp/mpvsocket | jq '.data | round')
                echo "$radio_prefix Current volume is "(_heat_volume $current_volume)
                return 0
            end

            set -l new_volume $argv[3]
            set -l min 1
            set -l max 100

            if string match -qr '^-?\d+$' -- $new_volume; and test $new_volume -ge $min; and test $new_volume -le $max
                echo '{"command": ["set_property", "volume", 30]}' | nc -N -U /tmp/mpvsocket &> /dev/null
                echo "$radio_prefix Change volume to "(_heat_volume $new_volume)
                return 0
            else
                echo "$radio_prefix $volume Invalid value. Please enter a integer number between 1 and 100."
                return 1
            end


        case "off"
            echo "$radio_prefix ⏸️ Shuting down radio..."
            pkill -f "title=RadioCLI" 2>/dev/null

            if test $status -eq 0
                echo "$radio_prefix 🛑 Radio closed."
                return 0
            else
                echo "$radio_prefix ⚠️ No active radio found."
                return 1
            end
    end
end
