from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(args: list[str]):
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str],
    answer: str,  # noqa: ARG001
    target_window_id: int,  # noqa: ARG001
    boss: Boss,
):
    target_tab_num = int(args[1])

    tm = boss.active_tab_manager

    current_idx = tm.tabs.index(tm.active_tab)
    target_idx = min(len(tm.tabs), target_tab_num) - 1

    tm.move_tab(delta=target_idx - current_idx)
