function streamDownloader --description 'Download Twitch/Kick VOD segments using ffmpeg'
    set -l stream_downloader_prefix "📹 Streamer Downloader:"
    # Check if ffmpeg is installed
    if not type -q ffmpeg
        echo "Error: ffmpeg is not installed."
        return 1
    end

    set -l help '📹 Streamer Downloader - Download Twitch/Kick VOD segments using ffmpeg

Usage:
    streamerDownloaeder [options] <url> <start-time> <duration> <output>

Options:
    -h, --help      This help

Examples:
    twitchDownloader \"https://...\" 00:10:00 00:05:00 clip.mp4"'

    if string match -q -- "$argv[1]" "-h" "--help"
        echo "$help"
        return 1
    end

    # Argument validation
    if test (count $argv) -ne 4
        echo "$help"
        return 1
    end

    set -l url $argv[1]
    set -l start $argv[2]
    set -l duration $argv[3]
    set -l output $argv[4]

    echo "Starting download: $duration starting at $start..."

    ffmpeg -ss $start -i "$url" -t $duration -c copy -bsf:a aac_adtstoasc "$output"

    set -l term_msg
    set -l notify_msg

    if test $status -eq 0
        set term_msg (set_color FFEF00)"Download finished successfully: "(set_color FF007F)"$output"(set_color normal)

        set notify_msg "Download finished successfully: <span foreground='#FF007F'><b>$output</b></span>"

        notify-send --app-name="FFmpeg" --icon="folder-download" "Download Concluído" "$notify_msg"
    else
        set term_msg (set_color FF073A)"Error: Download failed."(set_color normal)

        set notify_msg "<span foreground='#FF073A'><b>Error: Download failed.</b></span>"

        notify-send --app-name="FFmpeg" --icon="dialog-error" --urgency=critical "Erro no Download" "$notify_msg"
    end

    # Exibe no terminal
    echo $term_msg
end
