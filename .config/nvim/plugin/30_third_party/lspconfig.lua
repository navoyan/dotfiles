local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("neovim/nvim-lspconfig"),
    })

    ---@type table<string, vim.lsp.Config>
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
        bashls = {},
        basedpyright = {
            settings = {
                basedpyright = {
                    analysis = {
                        diagnosticMode = "workspace",
                    },
                },
            },
        },
        ruff = {
            init_options = {
                settings = {
                    configuration = { lint = { fixable = { "ALL" } } },
                },
            },
        },
        ts_ls = {
            on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
            end,
        },
        eslint = {},
        gopls = {},
        clangd = {},
        helm_ls = {},
        yamlls = {
            settings = {
                yaml = {
                    format = {
                        printWidth = 500,
                    },
                },
            },
        },
        jsonls = {},
        tombi = { root_markers = { "." } },
        typos_lsp = {
            init_options = {
                diagnosticSeverity = "Warning",
            },
        },
    }

    local blink_cmp = require("blink.cmp")

    for server, ls_config in pairs(servers) do
        ls_config.capabilities = blink_cmp.get_lsp_capabilities()
        vim.lsp.config(server, ls_config)
        vim.lsp.enable(server)
    end

    config.new_autocmd("LspAttach", "*", function(event)
        local map = function(modes, lhs, rhs)
            vim.keymap.set(modes, lhs, rhs, { buffer = event.buf })
        end

        local picker = Snacks.picker

        -- Jump to the definition of the word under the cursor.
        map("n", "gd", picker.lsp_definitions)

        -- Jump to the declaration of the word under the cursor.
        -- For example, in C this would take to the header.
        map("n", "gD", vim.lsp.buf.declaration)

        -- Find references for the word under the cursor.
        map("n", "gr", picker.lsp_references)

        -- Jump to the implementation of the word under the cursor.
        -- Useful when language has ways of declaring types without an actual implementation.
        map("n", "gI", picker.lsp_implementations)

        -- Jump to the type of the symbol under the cursor.
        map("n", "gy", picker.lsp_type_definitions)

        -- Fuzzy find all the symbols in current document.
        map("n", "<Leader>sd", picker.lsp_symbols)

        -- Fuzzy find all the symbols in current workspace.
        map("n", "<Leader>sw", picker.lsp_workspace_symbols)

        -- Execute a code action
        map({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action)

        -- Show diagnostics for the current line in a floating window.
        map("n", "<Leader>cd", function()
            vim.diagnostic.open_float({ scope = "line" })
        end)

        -- Enable global inlay hints.
        map("n", "<Leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end)

        -- Opens a popup that displays documentation about the word under the cursor.
        map("n", "K", vim.lsp.buf.hover)
    end)
end)
