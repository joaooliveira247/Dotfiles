#!/usr/bin/env bash

CACHE_DIR="/tmp/mpris_covers"
mkdir -p "$CACHE_DIR"

# last track id
LAST_TRACK=""

# search album cover art on deezer qpi
get_deezer_cover() {
    local query_text="$1"

    local query
    query=$(echo "$query_text" | jq -sRr @uri 2>/dev/null)
    [ -z "$query" ] && return

    local response
    response=$(curl -s "https://api.deezer.com/search?q=${query}&limit=1")

    local cover_url
    cover_url=$(echo "$response" | jq -r '.data[0].album.cover_big // empty' 2>/dev/null)

    if [ -n "$cover_url" ] && [ "$cover_url" != "null" ]; then
        local img_path="$CACHE_DIR/deezer_$(echo -n "$query_text" | md5sum | awk '{print $1}').jpg"
        if [ ! -f "$img_path" ]; then
            curl -s "$cover_url" -o "$img_path"
        fi
        echo "$img_path"
    fi
}

playerctl --player=spotify,mpv metadata --format '{{playerName}}|{{artist}}|{{title}}|{{mpris:artUrl}}' --follow | while IFS='|' read -r PLAYER ARTIST TITLE ART_URL; do
    if [[ "$PLAYER" != "spotify" && "$PLAYER" != "mpv" ]]; then
        continue
    fi

    # check if title is empty
    [ -z "$TITLE" ] && continue

    CLEAN_TITLE="$TITLE"
    CLEAN_ARTIST="$ARTIST"

    
    if [ -z "$CLEAN_ARTIST" ] && [[ "$TITLE" == *" - "* ]]; then
        CLEAN_ARTIST=$(echo "$TITLE" | awk -F ' - ' '{print $1}')
        CLEAN_TITLE=$(echo "$TITLE" | awk -F ' - ' '{print $2}')
        SEARCH_QUERY="$TITLE"
    else
        SEARCH_QUERY="$CLEAN_ARTIST $CLEAN_TITLE"
    fi

    # check if is same of last_track
    CURRENT_TRACK_ID="${PLAYER}:${SEARCH_QUERY}"
    if [ "$CURRENT_TRACK_ID" = "$LAST_TRACK" ]; then
        continue
    fi

    LAST_TRACK="$CURRENT_TRACK_ID"

    if [ -n "$CLEAN_ARTIST" ]; then
        DISPLAY_TEXT="📀 <b>$CLEAN_TITLE</b>\n🎤 <i>$CLEAN_ARTIST</i>"
    else
        DISPLAY_TEXT="📀 <b>$CLEAN_TITLE</b>"
    fi

    FINAL_COVER=""

    # when mpris get from spotify
    if [ -n "$ART_URL" ]; then
        if [[ "$ART_URL" == http* ]]; then
            LOCAL_IMG="$CACHE_DIR/remote_$(echo -n "$ART_URL" | md5sum | awk '{print $1}').jpg"
            if [ ! -f "$LOCAL_IMG" ]; then
                curl -s "$ART_URL" -o "$LOCAL_IMG"
            fi
            FINAL_COVER="$LOCAL_IMG"
        elif [[ "$ART_URL" == file://* ]]; then
            FINAL_COVER="${ART_URL#file://}"
        fi
    fi

    # when mpris control mpv/webradio
    if [ -z "$FINAL_COVER" ] || [ ! -f "$FINAL_COVER" ]; then
        FINAL_COVER=$(get_deezer_cover "$SEARCH_QUERY")
    fi

    # send sys notify
    if [ -n "$FINAL_COVER" ] && [ -f "$FINAL_COVER" ]; then
        notify-send -a "$PLAYER" -i "$FINAL_COVER" "🎶 Playing now" "$DISPLAY_TEXT" -r 9992 -t 5000
    else
        notify-send -a "$PLAYER" -i "audio-x-generic" "🎶 Playing now" "$DISPLAY_TEXT" -r 9992 -t 5000
    fi
done
