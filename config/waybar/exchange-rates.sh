#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

# NOTE: there are special rates in apps

ameria_rate=$(
  curl --silent --fail \
    'https://ameriabank.am/DesktopModules/DNNExchangeCalculator/convert.ashx?fromCurrency=USD&toCurrency=AMD&cash=false&amount=1' \
    | awk '{ print $1 * 1.002 }' \
    | numfmt --format '%.2f'
)
ardshin_rate=$(
  curl --silent --fail \
    'https://ardshinbank.am/api/currency' \
    | jq '.data.currencies.no_cash[] | select(.type == "USD") | .buy | tonumber * 1.00066' \
    | numfmt --format '%.2f'
)

jq --null-input --unbuffered --compact-output \
  --arg text " $ameria_rate/$ardshin_rate" \
  --arg tooltip "Ameria: $ameria_rate / Ardshin: $ardshin_rate" \
  '{ "text": $text, "tooltip": $tooltip }'
