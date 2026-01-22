local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

local function picker_config()
    --- @param ctx snacks.picker.preview.ctx
    --- @return boolean?
    local function preview_with_full_filepath(ctx)
        local res = Snacks.picker.preview.file(ctx)
        if ctx.item.file then
            ctx.picker.preview:set_title(ctx.item.file)
        end
        return res
    end

    ---@type snacks.picker.Config
    return {
        matcher = {
            frecency = true,
        },
        formatters = {
            file = {
                filename_first = true,
                truncate = 60,
            },
        },
        win = {
            input = {
                keys = {
                    ["<c-k>"] = { "list_scroll_up", mode = { "i", "n" } },
                    ["<c-j>"] = { "list_scroll_down", mode = { "i", "n" } },
                },
            },
            list = {
                keys = {
                    ["<c-k>"] = { "list_scroll_up", mode = { "i", "n" } },
                    ["<c-j>"] = { "list_scroll_down", mode = { "i", "n" } },
                    ["/"] = false,
                },
            },
        },
        layouts = {
            default = {
                layout = {
                    box = "horizontal",
                    width = 0.8,
                    min_width = 120,
                    height = 0.8,
                    {
                        box = "vertical",
                        width = 0.45,
                        {
                            win = "input",
                            height = 1,
                            title = "{title} {live} {flags}",
                            border = "single",
                        },
                        { win = "list", border = "none" },
                    },
                    {
                        win = "preview",
                        -- there is no statuscolumn gap in minimal style
                        style = "minimal",
                        title = "{preview}",
                        border = "single",
                        width = 0.55,
                    },
                },
            },
            ivy = {
                preview = "main",
                layout = {
                    box = "vertical",
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.4,
                    {
                        win = "input",
                        height = 1,
                        border = "single",
                        title_pos = "left",
                        title = "{title} {live} {flags}",
                    },
                    {
                        box = "horizontal",
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", width = 0.6, border = "left" },
                    },
                },
            },
            ivy_no_preview = {
                layout = {
                    box = "vertical",
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.4,
                    {
                        win = "input",
                        height = 1,
                        border = "single",
                        title_pos = "left",
                        title = "{title} {live} {flags}",
                    },
                    { win = "list", border = "none" },
                },
            },
            select = {
                layout = {
                    backdrop = false,
                    width = 0.4,
                    min_width = 80,
                    height = 0.4,
                    min_height = 3,
                    box = "vertical",
                    border = "single",
                    title = "{title}",
                    title_pos = "center",
                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", border = "none" },
                    { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                },
            },
            vertical = {
                layout = {
                    backdrop = false,
                    width = 0.5,
                    min_width = 80,
                    height = 0.8,
                    min_height = 30,
                    box = "vertical",
                    border = "single",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", border = "none" },
                    { win = "preview", style = "minimal", title = "{preview}", height = 0.4, border = "top" },
                },
            },
            code_action = {
                layout = {
                    backdrop = false,
                    width = 0.6,
                    min_width = 80,
                    height = 0.6,
                    min_height = 30,
                    box = "vertical",
                    border = "single",
                    title = "Code Action",
                    title_pos = "center",
                    { win = "list", height = 0.2, border = "none" },
                    { win = "preview", title = "{preview}", border = "top" },
                },
            },
        },
        sources = {
            select = { focus = "list" },
            files = { preview = preview_with_full_filepath, hidden = true },
            grep = { preview = preview_with_full_filepath, hidden = true },
            grep_word = { preview = preview_with_full_filepath, hidden = true },
            buffers = { preview = preview_with_full_filepath },
            grep_buffers = { preview = preview_with_full_filepath },
            diagnostics_buffer = { layout = "ivy", focus = "list" },
            diagnostics = { layout = "ivy", focus = "list" },
            lsp_definitions = { layout = "ivy", focus = "list" },
            lsp_references = { layout = "ivy", focus = "list" },
            lsp_implementations = { layout = "ivy", focus = "list" },
            lsp_type_definitions = { layout = "ivy", focus = "list" },
            lsp_symbols = { layout = "ivy", focus = "list" },
            lsp_workspace_symbols = { layout = "ivy", focus = "list" },
            command_history = { layout = "ivy_no_preview", focus = "list" },
        },
    }
end

local function picker_create_mappings()
    local picker = Snacks.picker

    local function conf(picker_fn, ...)
        local configs = { ... }
        return function()
            local result_config = {}
            for _, config_fn in ipairs(configs) do
                result_config = vim.tbl_deep_extend("error", result_config, config_fn())
            end

            picker_fn(result_config)
        end
    end

    map("n", "<Leader>sp", picker.resume)

    map("n", "<Leader>ff", picker.files)
    map("n", "<Leader>fo", picker.buffers)
    map("n", "<Leader>fg", picker.git_status)
    map("n", "<Leader>fp", picker.projects)

    map("n", "<Leader>sf", picker.grep)
    map("n", "<Leader>so", picker.grep_buffers)
    map("n", "<Leader>sg", picker.git_grep)
    map({ "n", "x" }, "<Leader>sc", picker.grep_word)

    map("n", "<Leader>ss", picker.lines)

    local vim_severity = vim.diagnostic.severity
    local function severity(picker_severity)
        return function()
            return { severity = picker_severity }
        end
    end

    map("n", "<Leader>dd", picker.diagnostics_buffer)
    map("n", "<Leader>dD", conf(picker.diagnostics_buffer, severity(vim_severity.ERROR)))
    map("n", "<Leader>dw", picker.diagnostics)
    map("n", "<Leader>dW", conf(picker.diagnostics, severity(vim_severity.ERROR)))

    map("n", "<Leader>su", picker.undo)
    map("n", "<Leader>sq", picker.qflist)

    map("n", "<Leader>sH", picker.help)
    map("n", "<Leader>sC", picker.commands)
    map("n", "<Leader>sK", picker.keymaps)
    map("n", "<Leader>sM", picker.man)

    local ctrl_c = vim.keycode("<C-c>")
    map("c", "<C-r>", function()
        local cmdline = vim.fn.getcmdline()
        vim.api.nvim_feedkeys(ctrl_c, "c", true)

        vim.schedule(function()
            picker.command_history({ pattern = cmdline })
        end)
    end)

    map("n", "<Leader>sT", picker.colorschemes)
end

schedule.now(function()
    vim.pack.add({
        {
            src = config.github("folke/snacks.nvim"),
            version = vim.version.range("*"),
        },
    })

    require("snacks").setup({
        picker = picker_config(),
        bigfile = {},
        statuscolumn = {
            left = { "sign" },
            right = { "git" },
        },
        words = {
            debounce = 10,
        },
        indent = {
            animate = {
                enabled = false,
            },
            scope = {
                enabled = false,
            },
        },
        image = {},
        dashboard = {
            sections = {
                { section = "header" },
            },
        },
    })

    picker_create_mappings()
end)
