#!/usr/bin/env bash

if [ -n "$1" ]; then
    cliphist decode <<< "$ROFI_INFO" | wl-copy
    exit 0
fi

cliphist list | while IFS=$'\t' read -r id content; do
    printf '%s\0info\x1f%s\t%s\n' "$content" "$id" "$content"
done
