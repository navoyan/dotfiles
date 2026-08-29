# pyright: basic

config = config  # noqa: F821 # pyright: ignore[reportUndefinedVariable]
c = c  # noqa: F821 # pyright: ignore[reportUndefinedVariable]


## Load settings done via GUI
config.load_autoconfig(True)

config.source("tokyonight.py")


c.auto_save.session = False

# ISSUE: forcing software rendering affects performance, but fixes screen sharing crashing.
# Almost the same issue as described here: https://github.com/qutebrowser/qutebrowser/discussions/8761
c.qt.force_software_rendering = "none"

c.content.site_specific_quirks.skip = ["ua-google"]

c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    ":g": "https://google.com/search?q={}",
    ":d": "https://www.deepl.com/en/translator#en/ru/{}",
    ":dd": "https://duckduckgo.com/?ia=web&q={}",
    ":aw": "https://wiki.archlinux.org/?search={}",
    ":ar": "https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=",
    ":aur": "https://aur.archlinux.org/packages/?K={}",
    ":gh": "https://github.com/search?o=desc&q={}&s=stars",
    ":ghc": "https://github.com/search?q={}&type=code",
    ":yt": "https://www.youtube.com/results?search_query={}",
}
c.url.start_pages = ["https://google.com"]
c.url.default_page = "https://google.com"

c.spellcheck.languages = ["en-US", "ru-RU"]

c.content.notifications.show_origin = False

c.tabs.new_position.related = "last"

c.tabs.position = "left"
c.tabs.padding = {"top": 5, "bottom": 5, "left": 9, "right": 9}
c.tabs.title.format = "{aligned_index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{aligned_index}  {audio}"

c.fonts.default_size = "12pt"
c.fonts.default_family = ["JetBrainsMono NFM"]

c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"


c.fileselect.handler = "external"
c.fileselect.folder.command = [
    "kitty",
    "--app-id=kitty-popup",
    "yazi",
    "--cwd-file={}",
]
c.fileselect.multiple_files.command = [
    "kitty",
    "--app-id=kitty-popup",
    "yazi",
    "--chooser-file={}",
]
c.fileselect.single_file.command = [
    "kitty",
    "--app-id=kitty-popup",
    "yazi",
    "--chooser-file={}",
]

c.editor.command = [
    "kitty",
    "--app-id=kitty-popup-small",
    "bash",
    "-c",
    "nvim '+set wrap' '+call cursor({line}, {column})' {file}",
]


c.aliases.update(
    {
        "work": "session-load work",
    }
)

c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_enter = False

config.bind("f", "fake-key f")

config.bind("k", "scroll-page 0 -0.1")
config.bind("j", "scroll-page 0 0.1")

config.bind("<Ctrl-K>", "scroll-page 0 -0.5")
config.bind("<Ctrl-J>", "scroll-page 0 0.5")

config.bind("<Backspace>", "hint")
config.bind("<Shift-Backspace>", "hint all tab")
config.bind("w<Backspace>", "hint all window")

config.bind(
    ";v",
    "spawn mpv {url} ;; " + f"jseval -qf {config.configdir}/jseval/pause_video.js",
)
config.bind(";V", "hint links spawn mpv {hint-url}")

config.bind("<Ctrl-O>", "back")
config.bind("<Ctrl-I>", "forward")

config.bind("H", "history")
config.bind("<Ctrl-H>", "history -t")

config.bind("go", "edit-url")
config.bind("<Ctrl-E>", "edit-text")

config.unbind("T")
default_binds = c.bindings.default["normal"]
keys_to_change = [key for key in default_binds if key.startswith("t")]
for key in keys_to_change:
    config.unbind(key)
    config.bind("T" + key[1:], default_binds[key])

config.bind("t", "cmd-set-text -sr :tab-select")
config.bind("gt", "cmd-set-text -sr :tab-focus")

config.bind("cj", "tab-only --prev")
config.bind("ck", "tab-only --next")

config.bind("<Shift-Down>", "tab-move +")
config.bind("<Shift-Up>", "tab-move -")

config.bind("e", "config-cycle tabs.show never always")

config.bind("^", "move-to-start-of-line", mode="caret")

config.bind("<Ctrl-Shift-V>", "mode-enter passthrough")
config.bind("<Ctrl-V>", "fake-key <Ctrl-V>")


en_keys = "qwertyuiopasdfghjklzxcvbnm" + "QWERTYUIOPASDFGHJKLZXCVBNM+"
ru_keys = "явертыуиопасдфгхйклзьцжбнм" + "ЯВЕРТЫУИОПАСДФГХЙКЛЗЬЦЖБНМЮ"
c.bindings.key_mappings.update(dict(zip(ru_keys, en_keys)))


c.content.javascript.log_message.excludes = {
    "userscript:_qute_stylesheet": [
        "*Refused to apply inline style because it violates the following Content Security Policy directive: *"
    ],
    "userscript:_qute_js": ["*TrustedHTML*"],
}
