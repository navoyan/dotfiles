#!/usr/bin/env bash

mute_sound="$HOME/.local/share/sounds/mute.mp3"
unmute_sound="$HOME/.local/share/sounds/unmute.mp3"

wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
    sound="$mute_sound"
else
    sound="$unmute_sound"
fi

pw-play --volume 0.35 "$sound"
