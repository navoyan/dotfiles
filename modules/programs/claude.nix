{
  pkgs,
  localLib,
  ...
}: let
  permissions = combinators:
    with combinators; [
      network

      # nix:
      (add-pkg-deps [pkgs.nix])
      (readonly "/nix/store")
      (readonly "/nix/var/nix")
      (readonly "/etc/nix/nix.conf")
      (ro-bind "${pkgs.nix-ld}/libexec/nix-ld" "/lib64/ld-linux-x86-64.so.2")

      # direnv
      (add-pkg-deps [pkgs.direnv])
      (wrap-entry (entry: ''
        direnv exec . ${entry}
      ''))
      (readonly (noescape "~/.config/direnv"))
      (readonly (noescape "~/.local/share/direnv"))

      # claude/mcp:
      (add-pkg-deps [pkgs.claude-code pkgs.codegraph])
      (set-env "CLAUDE_CONFIG_DIR" (noescape "~/.config/claude"))
      (readwrite (noescape "~/.config/claude"))
      (readwrite (noescape "~/.config/anthropic"))
      (rw-bind (noescape "~/.local/share/codegraph") (noescape "~/.codegraph"))

      # projects:
      (readwrite (noescape "~/projects"))
      (readwrite (noescape "~/dotfiles"))
      (readwrite (noescape "~/vaults"))

      # workflow:
      (fwd-env "EDITOR")
      (add-pkg-deps [pkgs.git pkgs.delta pkgs.neovim])
      (readonly (noescape "~/.config/git"))
      (readonly (noescape "~/.config/nvim"))
      (readonly (noescape "~/.local/share/nvim"))
      (readwrite (noescape "~/.local/state/nvim"))

      # rust:
      (fwd-env "RUSTUP_HOME")
      (fwd-env "CARGO_HOME")
      (readwrite (noescape "~/.local/share/rustup"))
      (readwrite (noescape "~/.local/share/cargo"))

      # python:
      (readwrite (noescape "~/.cache/uv"))
      (readwrite (noescape "~/.local/share/uv"))
    ];

  claudeJailed =
    localLib.jail.pkg "claude" pkgs.claude-code permissions;
in {
  environment.systemPackages = [claudeJailed];
}
