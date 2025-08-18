return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            "nvim-lua/plenary.nvim",

            "saghen/blink.cmp",

            "j-hui/fidget.nvim",
        },
        opts = {
            servers = {
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = {...},
                    -- capabilities = {},
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
                typos_lsp = {
                    init_options = {
                        diagnosticSeverity = "Warning",
                    },
                },
            },
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-config-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    local picker = Snacks.picker

                    -- Jump to the definition of the word under the cursor.
                    map("gd", picker.lsp_definitions, "[G]oto [D]efinition")

                    -- Jump to the declaration of the word under the cursor.
                    -- For example, in C this would take to the header.
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- Find references for the word under the cursor.
                    map("gr", picker.lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under the cursor.
                    -- Useful when language has ways of declaring types without an actual implementation.
                    map("gI", picker.lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the type of the symbol under the cursor.
                    map("gy", picker.lsp_type_definitions, "[G]oto T[y]pe Definition")

                    -- Fuzzy find all the symbols in current document.
                    -- Symbols are things like variables, functions, types, etc.
                    map("<leader>sd", picker.lsp_symbols, "[S]ymbols in [D]ocument")

                    -- Fuzzy find all the symbols in current workspace.
                    map("<leader>sw", picker.lsp_workspace_symbols, "[S]ymbols in [W]orkspace")

                    -- Show diagnostics for the current line in a floating window.
                    map("<leader>cd", function()
                        vim.diagnostic.open_float({ scope = "line" })
                    end, "[C]ode [D]iagnostics")

                    -- Enable global inlay hints.
                    map("<leader>ch", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                    end, "[C]ode Inlay [H]ints")

                    -- Opens a popup that displays documentation about the word under the cursor.
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                end,
            })

            local lspconfig = require("lspconfig")
            local blink_cmp = require("blink.cmp")

            for server, config in pairs(opts.servers) do
                config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end,
    },
    {
        "saecki/live-rename.nvim",
        event = "LspAttach",
        config = function()
            local live_rename = require("live-rename")

            local function rename_fn(opts)
                return function()
                    live_rename.rename(opts)

                    -- NOTE: needed to disable completions
                    vim.bo.filetype = "liverename"
                end
            end

            local map = vim.keymap.set

            map("n", "<leader>rn", rename_fn(), {
                desc = "LSP: [R]ename (in [N]ormal mode)",
            })
            map("n", "<leader>ri", rename_fn({ text = "", insert = true }), {
                desc = "LSP: [R]ename (in [I]nsert mode)",
            })
        end,
    },
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "folke/snacks.nvim",
                opts = {
                    terminal = {},
                },
            },
        },
        event = "LspAttach",
        keys = {
            {
                "<leader>ca",
                function()
                    require("tiny-code-action").code_action({})
                end,
                mode = { "n", "x" },
            },
        },
        opts = {
            picker = {
                "snacks",
                opts = {
                    layout = "code_action",
                },
            },
            backend = "difftastic",
            backend_opts = {
                difftastic = {
                    header_lines_to_remove = 1,

                    args = {
                        "--color=always",
                        "--syntax-highlight=on",
                        "--display=inline",
                        "--width=105",
                    },
                },
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },

                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "mini.bracketed", words = { "MiniBracketed" } },
                { path = "mini.files", words = { "MiniFiles" } },
                { path = "mini.extra", words = { "MiniExtra" } },
            },
        },
    },
}
