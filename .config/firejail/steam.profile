ignore blacklist ${PATH}/timedatectl

ignore mkdir ${HOME}/.factorio
ignore mkdir ${HOME}/.killingfloor
ignore mkdir ${HOME}/.klei
ignore mkdir ${HOME}/.mbwarband
ignore mkdir ${HOME}/.paradoxinteractive
ignore mkdir ${HOME}/.paradoxlauncher
ignore mkdir ${HOME}/.prey
ignore mkdir ${HOME}/Zomboid

# `steam -steamos3` is powering off bluetooth via D-Bus on startup.
# Firejail support for filtering D-Bus calls is only whitelist-based:
dbus-system filter
dbus-system.talk org.freedesktop.NetworkManager
dbus-system.talk org.freedesktop.Avahi
dbus-system.talk org.freedesktop.login1
dbus-system.talk org.freedesktop.hostname1


include game.profile
include /etc/firejail/steam.profile
