local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("neovim/nvim-lspconfig"),
    })

    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
        },
        basedpyright = {
            settings = {
                basedpyright = {
                    analysis = {
                        diagnosticMode = "workspace",
                    },
                },
            },
        },
        ruff = {},
        ts_ls = {
            filetypes = { "javascript" },
        },
        gopls = {},
        helm_ls = {},
        yamlls = {},
        jsonls = {},
        taplo = {},
        typos_lsp = {
            init_options = {
                diagnosticSeverity = "Warning",
            },
        },
    }

    local blink_cmp = require("blink.cmp")

    for server, ls_config in pairs(servers) do
        ls_config.capabilities = blink_cmp.get_lsp_capabilities(ls_config.capabilities)
        vim.lsp.config(server, ls_config)
        vim.lsp.enable(server)
    end

    config.new_autocmd("LspAttach", "*", function(event)
        local map = function(keys, func)
            vim.keymap.set("n", keys, func, { buffer = event.buf })
        end

        local picker = Snacks.picker

        -- Jump to the definition of the word under the cursor.
        map("gd", picker.lsp_definitions)

        -- Jump to the declaration of the word under the cursor.
        -- For example, in C this would take to the header.
        map("gD", vim.lsp.buf.declaration)

        -- Find references for the word under the cursor.
        map("gr", picker.lsp_references)

        -- Jump to the implementation of the word under the cursor.
        -- Useful when language has ways of declaring types without an actual implementation.
        map("gI", picker.lsp_implementations)

        -- Jump to the type of the symbol under the cursor.
        map("gy", picker.lsp_type_definitions)

        -- Fuzzy find all the symbols in current document.
        map("<Leader>sd", picker.lsp_symbols)

        -- Fuzzy find all the symbols in current workspace.
        map("<Leader>sw", picker.lsp_workspace_symbols)

        -- Execute a code action
        map("<Leader>ca", vim.lsp.buf.code_action)

        -- Show diagnostics for the current line in a floating window.
        map("<Leader>cd", function()
            vim.diagnostic.open_float({ scope = "line" })
        end)

        -- Enable global inlay hints.
        map("<Leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end)

        -- Opens a popup that displays documentation about the word under the cursor.
        map("K", vim.lsp.buf.hover)
    end)
end)
