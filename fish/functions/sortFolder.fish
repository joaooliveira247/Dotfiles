function sortFolder --description "sort items recursive into folder like photos/videos/docs"
        set -l sort_folder_prefix "📂 Sort Folder"
        set -l input_path $argv[1]
        if test -z "$input_path"
            set input_path .
        end

        set -l help '📂 Sort Folder - Sort items recursive into folder like photos/videos/docs

Usage:
    sortFolder [options] <path>

Arguments:
    <path>            Path to folder (Default is current directory)

Options:
    -h, --help      This help

Examples:
    sortFolder              # Sort Current directory
    sortFolder ~/Downloads  # Sort Downloads folder'

        if string match -q -- "$argv[1]" "-h" "--help"
            echo "$help"
            return 1
        end

        set -l target (realpath $input_path 2>/dev/null)

        if test -z "$target"; or not test -d "$target"
            echo "$sort_folder_prefix (❌ Error) Target directory '$input_path' does not exist."
            return 1
        end

        if test "$target" = "/" -o "$target" = "$HOME" -o "$target" = "/root"
            echo "$sort_folder_prefix (⛔ ACTION BLOCKED) Execution on root or direct HOME folder is not allowed."
            return 1
        end

        if string match -q -r '^/(etc|usr|var|proc|sys|dev|bin|sbin|lib)($|/)' "$target"
            echo "$sort_folder_prefix (⛔ ACTION BLOCKED) Direct system folder target detected."
            return 1
        end

        echo "$sort_folder_prefix (🔍 Scanning target) $target"

        set -l photos_dir "$target/Fotos"
        set -l videos_dir "$target/Videos"
        set -l docs_dir "$target/Documentos"


        set -l photos (find "$target" -type f \
            \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) \
            ! -path "$photos_dir/*" ! -path "$videos_dir/*" ! -path "$docs_dir/*")

        if test -n "$photos"
            mkdir -p "$photos_dir"
            for file in $photos
                set -l filename (basename "$file")
                mv "$file" "$photos_dir/"
                echo "$sort_folder_prefix (📸 Moved) $filename ➔ Fotos/"
            end
        end

        set -l videos (find "$target" -type f \
            \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" \) \
            ! -path "$photos_dir/*" ! -path "$videos_dir/*" ! -path "$docs_dir/*")

        if test -n "$videos"
            mkdir -p "$videos_dir"
            for file in $videos
                set -l filename (basename "$file")
                mv "$file" "$videos_dir/"
                echo "$sort_folder_prefix (🎥 Moved) $filename ➔ Videos/"
            end
        end

        set -l docs (find "$target" -type f \
            \( -iname "*.pdf" -o -iname "*.docx" -o -iname "*.epub" \) \
            ! -path "$photos_dir/*" ! -path "$videos_dir/*" ! -path "$docs_dir/*")

        if test -n "$docs"
            mkdir -p "$docs_dir"
            for file in $docs
                set -l filename (basename "$file")
                mv "$file" "$docs_dir/"
                echo "$sort_folder_prefix (📄 Moved) $filename ➔ Documentos/"
            end
        end

        echo "$sort_folder_prefix ✨ Folder organization complete!"
        notify-send --app-name="sortFolder" --icon="terminal" "✨ Folder organization complete!"
    end
