local schedule, config = require("schedule"), require("config")

local function picker_config()
    local function preview_with_full_filepath(ctx)
        local res = Snacks.picker.preview.file(ctx)
        if ctx.item.file then
            ctx.picker.preview:set_title(ctx.item.file)
        end
        return res
    end

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
        debug = {
            scores = false,
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
            inline_preview = {
                preview = "main",
                layout = {
                    backdrop = false,
                    row = 1,
                    width = 0.4,
                    min_width = 80,
                    height = 0.4,
                    border = "none",
                    box = "vertical",
                    {
                        win = "input",
                        height = 1,
                        border = "single",
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                    },
                    { win = "list", border = "hpad" },
                    { win = "preview", title = "{preview}", border = "single" },
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
            files = { preview = preview_with_full_filepath },
            grep = { preview = preview_with_full_filepath },
            grep_word = { preview = preview_with_full_filepath },
            buffers = { preview = preview_with_full_filepath },
            grep_buffers = { preview = preview_with_full_filepath },
            select = { focus = "list" },
            diagnostics_buffer = { layout = "inline_preview", focus = "list" },
            diagnostics = { layout = "inline_preview", focus = "list" },
            lsp_definitions = { layout = "inline_preview", focus = "list" },
            lsp_references = { layout = "inline_preview", focus = "list" },
            lsp_implementations = { layout = "inline_preview", focus = "list" },
            lsp_type_definitions = { layout = "inline_preview", focus = "list" },
            lsp_symbols = { layout = "inline_preview", focus = "list" },
            lsp_workspace_symbols = { focus = "list", layout = "inline_preview" },
        },
    }
end

local function picker_create_mappings()
    local is_cwd_dotfiles = function()
        return vim.fn.getcwd() == vim.env.HOME .. "/dotfiles"
    end
    local show_hidden_for_dotfiles = function()
        return is_cwd_dotfiles() and { hidden = true } or {}
    end

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

    local map = vim.keymap.set

    map("n", "<Leader>sp", Snacks.picker.resume)

    map("n", "<Leader>ff", conf(Snacks.picker.files, show_hidden_for_dotfiles))
    map("n", "<Leader>fo", Snacks.picker.buffers)
    map("n", "<Leader>fg", Snacks.picker.git_status)
    map("n", "<Leader>fp", Snacks.picker.projects)

    map("n", "<Leader>sf", conf(Snacks.picker.grep, show_hidden_for_dotfiles))
    map("n", "<Leader>so", Snacks.picker.grep_buffers)
    map("n", "<Leader>sg", Snacks.picker.git_grep)
    map({ "n", "x" }, "<Leader>sc", conf(Snacks.picker.grep_word, show_hidden_for_dotfiles))

    map("n", "<Leader>ss", Snacks.picker.lines)

    local vim_severity = vim.diagnostic.severity
    local function severity(picker_severity)
        return function()
            return { severity = picker_severity }
        end
    end

    map("n", "<Leader>dd", Snacks.picker.diagnostics_buffer)
    map("n", "<Leader>dD", conf(Snacks.picker.diagnostics_buffer, severity(vim_severity.ERROR)))
    map("n", "<Leader>dw", Snacks.picker.diagnostics)
    map("n", "<Leader>dW", conf(Snacks.picker.diagnostics, severity(vim_severity.ERROR)))

    map("n", "<Leader>su", Snacks.picker.undo)
    map("n", "<Leader>sq", Snacks.picker.qflist)

    map("n", "<Leader>sH", Snacks.picker.help)
    map("n", "<Leader>sC", Snacks.picker.commands)
    map("n", "<Leader>sK", Snacks.picker.keymaps)
    map("n", "<Leader>sM", Snacks.picker.man)

    local esc = vim.keycode("<Esc>")
    local function command_history()
        vim.api.nvim_feedkeys(esc, "c", true)

        vim.defer_fn(function()
            Snacks.picker.command_history()
        end, 1)
    end

    map("c", "<C-r>", command_history)

    map("n", "<Leader>sT", Snacks.picker.colorschemes)
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
        quickfile = {},
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
        -- TODO: setup `gitbrowse`
    })

    picker_create_mappings()
end)
