# For whatever reason Telegram generates new desktop entry on each update.
# These entries have higher priority (because of filename?) than the `org.telegram.desktop.desktop`,
# which disables my custom launch behaviour.

read-only ${HOME}/.local/share/applications
read-only ${HOME}/.config/mimeapps.list
