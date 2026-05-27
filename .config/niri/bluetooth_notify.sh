#!/usr/bin/env bash

udevadm monitor --udev --subsystem-match=input --property | while read -r line; do
    if [[ "$line" =~ ^UDEV.*\ ([[:alpha:]]+)\ .*/devices/ ]]; then
        # the action from the 'UDEV' header line:
        action="${BASH_REMATCH[1]}"

    # `NAME="<captured_group> (AVRCP)"`:
    elif [[ "$line" =~ ^NAME=\"(.*)[[:space:]]*\(AVRCP\)\"$ ]]; then
        # the AVCRP device name:
        device_name="${BASH_REMATCH[1]}"

        case "$action" in
            add) state="Connected" ;;
            remove) state="Disconnected" ;;
            *) continue ;;
        esac

        notify-send --transient "󰂯 $device_name" "$state"
    fi
done
