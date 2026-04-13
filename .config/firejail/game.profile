# for gamescope:
include allow-lua.inc

# for xwayland:
ignore noroot
ignore private-tmp
noblacklist /tmp/.wine-*


include base.profile


noblacklist ${HOME}/Data/Steam
whitelist ${HOME}/Data/Steam

noblacklist ${HOME}/Data/Games
whitelist ${HOME}/Data/Games

noblacklist ${HOME}/Games
whitelist ${HOME}/Games

noblacklist ${HOME}/.local/share/goverlay
whitelist ${HOME}/.local/share/goverlay
