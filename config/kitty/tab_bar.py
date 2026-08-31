from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    apply_title_template,
    as_rgb,
    draw_attributed_string,
)
from kitty.utils import color_as_int


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,  # noqa: ARG001
) -> int:
    _draw_left_status(
        draw_data=draw_data,
        screen=screen,
        tab=tab,
        before=before,
        max_tab_length=max_tab_length,
        index=index,
        is_last=is_last,
    )
    return _draw_right_status(
        draw_data=draw_data,
        screen=screen,
        tab=tab,
        is_last=is_last,
    )


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
) -> int:
    if draw_data.leading_spaces:
        screen.draw(" " * draw_data.leading_spaces)

    draw_tab_title(draw_data, screen, tab, index, max_tab_length)

    trailing_spaces = min(max_tab_length - 1, draw_data.trailing_spaces)
    max_tab_length -= trailing_spaces

    extra = screen.cursor.x - before - max_tab_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")

    if trailing_spaces:
        screen.draw(" " * trailing_spaces)

    end = screen.cursor.x

    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0

    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)

    screen.cursor.bg = 0

    return end


def draw_tab_title(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    index: int,
    max_title_length: int = 0,
) -> None:
    title = apply_title_template(draw_data, tab, index, max_title_length)
    before_draw = screen.cursor.x

    screen.draw(" ")
    draw_attributed_string(title, screen)

    if draw_data.max_tab_title_length > 0:
        x_limit = before_draw + draw_data.max_tab_title_length
        if screen.cursor.x > x_limit:
            screen.cursor.x = x_limit - 1
            screen.draw("…")

    screen.draw(" ")


ACTIVE_LAYOUT: str | None = None


def _draw_right_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    is_last: bool,
) -> int:
    global ACTIVE_LAYOUT
    if tab.is_active:
        ACTIVE_LAYOUT = tab.layout_name

    if not is_last:
        return screen.cursor.x

    if ACTIVE_LAYOUT is None or ACTIVE_LAYOUT == "splits":
        return screen.cursor.x

    active_layout_indicator = f" {ACTIVE_LAYOUT} "

    right_status_length = len(active_layout_indicator)

    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    screen.cursor.bold = True
    screen.cursor.fg = as_rgb(int(draw_data.active_fg))
    screen.cursor.bg = as_rgb(int(draw_data.active_bg))
    screen.draw(active_layout_indicator)

    screen.cursor.fg = 0
    screen.cursor.bg = 0

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x
