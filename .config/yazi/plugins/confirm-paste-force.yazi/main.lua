local M = {}

local count_yanked = ya.sync(function()
    return #cx.yanked
end)

function M:entry()
    if count_yanked() == 0 then
        return
    end

    local yes = ya.confirm({
        pos = { "center", w = 45, h = 6 },
        title = ui.Line("Paste yanked files?"):bold(),
        body = ui.Text("This will overwrite the destination files if they exist"):wrap(ui.Wrap.YES),
    })

    if yes then
        ya.emit("paste", { force = true })
    end
end

return M
