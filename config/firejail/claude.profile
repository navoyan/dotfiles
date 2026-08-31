# upstream configs:
# - https://github.com/netblue30/firejail/blob/master/etc/profile-a-l/claude.profile
# - https://github.com/netblue30/firejail/blob/master/etc/profile-a-l/llm-agent-common.profile

quiet


whitelist ${HOME}/.claude
whitelist ${HOME}/.claude.json

whitelist ${HOME}/.config/git/
read-only ${HOME}/.config/git/

whitelist ${HOME}/.config/nvim/
read-only ${HOME}/.config/nvim/
whitelist ${HOME}/.local/share/nvim/
read-only ${HOME}/.config/nvim/
whitelist ${HOME}/.local/state/nvim/
read-only ${HOME}/.config/nvim/
whitelist ${HOME}/.vimrc
read-only ${HOME}/.vimrc

whitelist ${HOME}/.rustup/
whitelist ${HOME}/go/
whitelist ${HOME}/.cargo/
whitelist ${HOME}/.cache/prek/
whitelist ${HOME}/.cache/pre-commit/
whitelist ${HOME}/.cache/uv/
whitelist ${HOME}/.local/share/uv/
whitelist ${HOME}/.cache/bazel/
whitelist ${HOME}/.cache/bazelisk/
whitelist ${HOME}/.cache/tombi/

whitelist ${HOME}/projects/
whitelist ${HOME}/dotfiles/
whitelist ${HOME}/vaults/


caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary

disable-mnt
private-dev
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
