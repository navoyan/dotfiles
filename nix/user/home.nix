{
  pkgs,
  lib,
  ...
}:
{
  hjem.users.narek =
    let
      genSymlinks =
        symlinkTarget: pathsToSymlink:
        lib.genAttrs pathsToSymlink (path: {
          source = "${symlinkTarget}/${path}";
        });
    in
    {
      xdg.config.files =
        let
          symlinks = genSymlinks "/home/narek/dotfiles/config" [
            "fish/config.fish"
            "fish/user_functions"
            "fish/themes"

            "kitty/kitty.conf"
            "kitty/tokyonight.conf"
            "kitty/tab_bar.py"
            "kitty/move_tab.py"

            "yazi/yazi.toml"
            "yazi/keymap.toml"
            "yazi/theme.toml"
            "yazi/package.toml"
            "yazi/plugins/confirm-paste-force.yazi"

            "qutebrowser/config.py"
            "qutebrowser/tokyonight.py"
            "qutebrowser/jseval"
            "qutebrowser/greasemonkey"

            "mpv/mpv.conf"
            "mpv/input.conf"
            "mpv/script-opts"
            "mpv/scripts/auto_enable_subs.lua"
            "mpv/scripts/osd_msgs.lua"
            "mpv/scripts/screenshot_dirs.lua"

            "git/config"

            "Vencord/themes"

            "rofi-rbw.rc"
            "lesskey"

            "bat"
            "direnv"
            "firejail"
            "imv"
            "k9s"
            "klassy"
            "lazygit"
            "niri"
            "npage"
            "nvim"
            "pipewire"
            "qtengine"
            "rofi"
            "swaync"
            "tmux"
            "waybar"
            "wezterm"
            "wiremix"
            "xdg-desktop-portal"
            "xkb"
            "yt-dlp"
            "zathura"
          ];

          fetchedFiles = {
            "mpv/scripts/mfpbar.lua".source = pkgs.fetchurl {
              url = "https://codeberg.org/NRK/mpv-toolbox/raw/commit/ca506127fe7a3f9235ead023d95c855f6c71c3d6/mfpbar/mfpbar.lua";
              hash = "sha256-YanKkURPcjtRmxO+I6dbdgiD/La7d1RfPzs4CJzAMYg=";
            };
            "mpv/scripts/thumbfast.lua".source = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/N-R-K/thumbfast/edbc294010bb0d7b3fc5f929c70c6f9b44132654/thumbfast.lua";
              hash = "sha256-OF3XPN8jY28DKIX2bB6DFAeEE9ZQDtUT+fnSLunHnh0=";
            };
            "mpv/scripts/thumbyt.lua".source = pkgs.fetchurl {
              url = "https://codeberg.org/NRK/mpv-toolbox/raw/commit/ca506127fe7a3f9235ead023d95c855f6c71c3d6/thumbyt/thumbyt.lua";
              hash = "sha256-/da8Cf8AajF1v1YNuPVLgdDmgoiCsPrdKYeUttoIZKs=";
            };
            "mpv/scripts/sponsorblock_minimal.lua".source = pkgs.fetchurl {
              url = "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/commit/8f4b186d6ea46e6fe0e5e94a53dda2f50dceb576/sponsorblock_minimal.lua";
              hash = "sha256-MWgy3ULYECCFwgg+w01pWwNLDvnuLbQMzCcTLpCd/bw=";
            };
          };
        in
        symlinks // fetchedFiles;

      xdg.data.files =
        let
          symlinks = genSymlinks "/home/narek/dotfiles/local/share" [
            "themes"

            "applications/google-meet.desktop"
            "applications/mongodb-compass.desktop"
            "applications/org.telegram.desktop.desktop"
            "applications/wiremix.desktop"
          ];

          fetchedFiles = {
            "qutebrowser/greasemonkey/yt_ads_bypass.js".source = pkgs.fetchurl {
              url = "https://update.greasyfork.org/scripts/575941/1849507/YouTube%20Ads-Bypass.user.js";
              hash = "sha256-SdANPGG210MgZo6FZO0REUuzA6rBTHGbuQ7s8wEHUDA=";
            };
            "qutebrowser/greasemonkey/remove_yt_shorts.js".source = pkgs.fetchurl {
              url = "https://update.greasyfork.org/scripts/522057/1865541/Remove%20YouTube%20Shorts.user.js";
              hash = "sha256-HAOh7QQm4SXT9X+fJ1x4paa2+P0KXoznZMm8Dxmd6gs=";
            };
          };
        in
        symlinks // fetchedFiles;
    };
}
