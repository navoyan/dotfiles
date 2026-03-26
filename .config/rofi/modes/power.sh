#!/usr/bin/env bash

set -o errexit -o nounset

all=(shutdown logout reboot firmware offmonitor suspend hibernate)

require_confirmation=(logout shutdown reboot firmware)

declare -A texts
texts[logout]="log out"
texts[shutdown]="shut down"
texts[reboot]="reboot"
texts[firmware]="firmware setup"
texts[offmonitor]="power off monitor"
texts[suspend]="suspend"
texts[hibernate]="hibernate"

declare -A icons
icons[logout]="󰍃"
icons[shutdown]="󰐥"
icons[reboot]="󰜉"
icons[firmware]="󰆍"
icons[offmonitor]="󰶐"
icons[suspend]="󰒲"
icons[hibernate]="󱛟"
icons[cancel]="󰜺"

declare -A actions
actions[logout]="niri msg action quit --skip-confirmation || hyprctl dispatch exit"
actions[shutdown]="systemctl poweroff"
actions[reboot]="systemctl reboot"
actions[firmware]="systemctl reboot --firmware-setup"
actions[offmonitor]="niri msg action power-off-monitors"
actions[suspend]="systemctl suspend"
actions[hibernate]="systemctl hibernate"
actions[cancel]="exit 0"

print_prompt() {
    printf "\0prompt\x1f%s\n" "$1"
}

print_with_info() {
    printf "%s\0info\x1f%s\n" "$1" "$2"
}

read -r status selection <<< "${ROFI_INFO:-}"

if [[ -z "$selection" ]]; then
    for entry in "${all[@]}"; do
        print_with_info "${icons[$entry]} ${texts[$entry]^}" "unconfirmed $entry"
    done
    exit 0
fi

if [[ $status == 'unconfirmed' ]] && printf '%s\0' "${require_confirmation[@]}" | grep -Fxzq "$selection"; then
    print_prompt "Are you sure"
    print_with_info "${icons[$selection]} Yes, ${texts[$selection]}" "confirmed $selection"
    print_with_info "${icons[cancel]} No, cancel" "confirmed cancel"
    exit 0
fi

eval "${actions[$selection]}"
