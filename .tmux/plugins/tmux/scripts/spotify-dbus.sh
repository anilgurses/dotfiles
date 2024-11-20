#!/usr/bin/env bash

# Thanks to https://askubuntu.com/questions/852366/how-to-get-the-name-of-the-music-currently-playing-in-spotify

get_track_name() {
    TRACK=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2)
}

get_artist_name() {
    ARTIST=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2)
}

get_status() {
    STATUS=$(gdbus call --session --dest org.mpris.MediaPlayer2.spotify --object-path /org/mpris/MediaPlayer2 --method org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player PlaybackStatus | cut -d "'" -f 2)
}

slideThroughText() {
    local spStr="${ARTIST} | ${TRACK}"
    local len=${#spStr}
    local display_len=20
    local padding="                    "

    local loopStr="${spStr}${padding}${spStr}${padding}"

    for (( i=0; i<len+${#padding}; i++ )); do
        TEXT="${loopStr:i:display_len}"
        echo -ne "\r♫ ${TEXT}"
        sleep 1
    done
}

main() {
    get_track_name
    get_artist_name
    get_status

    # Add option for
    if [ $STATUS = "Playing" ]; then
        slideThroughText
    else
        echo "⏸"
    fi
}

main
