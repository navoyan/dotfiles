local schedule, config = require("schedule"), require("config")

local RA_CLIENT_NAME = "rust-analyzer"

local function rust_lsp_cmd_fn(...)
    local args = ...

    return function()
        local ok, _ = pcall(vim.cmd.RustLsp, args)
        if not ok then
            -- BUG: RustLsp command is not re-created after `:RustAnalyzer restart`
            require("rustaceanvim.commands").create_rust_lsp_command()

            vim.cmd.RustLsp(args)
        end
    end
end

local related_diagnostics = rust_lsp_cmd_fn("relatedDiagnostics")
local rebuild_proc_macros = rust_lsp_cmd_fn("rebuildProcMacros")
local expand_macro = rust_lsp_cmd_fn("expandMacro")

local function rebuild_and_expand_macro(client)
    local macro_win = vim.api.nvim_get_current_win()
    local macro_pos = vim.api.nvim_win_get_cursor(macro_win)

    config.new_autocmd("LspProgress", "end", function(args)
        local data = args.data
        if not data then
            return
        end

        if data.client_id == client.id and data.params.token == "rustAnalyzer/cachePriming" then
            vim.api.nvim_win_set_cursor(macro_win, macro_pos)
            expand_macro()
            return true
        end
    end)

    rebuild_proc_macros()
end

local function ra_restart()
    vim.cmd.RustAnalyzer("restart")
end

local function switch_checker_and_restart()
    local check_cmd = vim.tbl_get(
        vim.lsp.config,
        RA_CLIENT_NAME,
        "default_settings",
        "rust-analyzer",
        "check",
        "command"
    ) or "check"

    check_cmd = check_cmd == "check" and "clippy" or "check"

    -- NOTE: rustaceanvim extends `opts.server.default_settings`
    -- with `vim.lsp.config[RA_CLIENT_NAME].default_settings`
    vim.lsp.config(RA_CLIENT_NAME, {
        default_settings = {
            ["rust-analyzer"] = {
                check = {
                    command = check_cmd,
                },
            },
        },
    })

    ra_restart()
end

local function ra_on_attach(client, bufnr)
    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>cr", related_diagnostics)

    map("n", "<leader>cp", rebuild_proc_macros)

    map("n", "<leader>cm", expand_macro)

    -- rebuild macros and expand macro under cursor
    map("n", "<leader>cM", function()
        rebuild_and_expand_macro(client)
    end)

    map("n", "<leader>cR", ra_restart)
    map("n", "<leader>cL", switch_checker_and_restart)
end

schedule.now(function()
    vim.pack.add({
        {
            src = config.github("mrcjkb/rustaceanvim"),
            version = vim.version.range("*"),
        },
    })

    vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
            on_attach = ra_on_attach,
            default_settings = {
                -- rust-analyzer language server configuration
                ["rust-analyzer"] = {
                    checkOnSave = true,
                    check = {
                        command = "check",
                    },
                    cargo = {
                        buildScripts = {
                            rebuildOnSave = true,
                        },
                    },
                    imports = {
                        granularity = {
                            group = "module",
                            enforce = true,
                        },
                        prefix = "crate",
                    },
                },
            },
        },
        -- DAP configuration
        dap = {},
    }
end)
