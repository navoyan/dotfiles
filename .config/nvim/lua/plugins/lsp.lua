return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        event = "LspAttach",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            "nvim-lua/plenary.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },

            { "folke/lazydev.nvim", ft = "lua", opts = {} },

            "nvimdev/lspsaga.nvim",
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-config-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Jump to the definition of the word under the cursor.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- Find references for the word under the cursor.
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under the cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the type of the symbol under the cursor.
                    map("gD", require("telescope.builtin").lsp_type_definitions, "[G]oto Type [D]efinition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>sd", require("telescope.builtin").lsp_document_symbols, "[S]ymbols in [D]ocument")

                    -- List all symbols in the current document (symbol structure)
                    map("<leader>ss", "<cmd>Lspsaga outline<cr>", "[S]ymbols [S]structure")

                    -- Find current symbol references in the current workspace
                    map("<leader>sf", "<cmd>Lspsaga finder<cr>", "[S]ymbols: [F]ind current word")

                    -- Peek the definition of the current symbol
                    map("<leader>sp", "<cmd>Lspsaga peek_definition<cr>", "[S]ymbol: [P]eek Definition")
                    -- Peek the type definition of the current symbol
                    map("<leader>st", "<cmd>Lspsaga peek_type_definition<cr>", "[S]ymbol: Peek [T]ype Definition")

                    -- Fuzzy find all the symbols in your current workspace.
                    map(
                        "<leader>sw",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[S]ymbols in [W]orkspace"
                    )

                    -- Rename the variable under the cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>rn", "<cmd>Lspsaga rename<cr>", "[R]e[n]ame")

                    -- Execute a code action aviailable for the current symbol or line
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
                        desc = "LSP: [C]ode [A]ction",
                    })

                    -- Show diagnostics for the current line in a floating window
                    map("<leader>cd", function()
                        vim.diagnostic.open_float({ scope = "line" })
                    end, "[C]ode [D]iagnostics")

                    -- Enable global inlay hints
                    map("<leader>ch", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                    end, "[C]ode Inlay [H]ints")

                    -- Jump to the next or previous diagnostic in the current buffer
                    map("<leader>dn", vim.diagnostic.goto_next, "[D]iagnostics: jump to [N]ext")
                    map("<leader>dN", vim.diagnostic.goto_prev, "[D]iagnostics: jump to previous")

                    -- Opens a popup that displays documentation about the word under the cursor
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- This is not Goto Definition, this is Goto Declaration.
                    --    For example, in C this would take you to the header.
                    map("<leader>D", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- The following two autocommands are used to highlight references of the
                    -- word under the cursor when the cursor rests there for a little while.
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- Enabled language servers
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                pyright = {
                    settings = {
                        autoImportCompletion = true,
                        python = {
                            analysis = {
                                typeCheckingMode = "off",
                            },
                        },
                    },
                },
                yamlls = {
                    settings = {
                        yaml = {
                            schemas = {
                                kubernetes = "*.yaml",
                                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                            },
                        },
                    },
                },
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
                tsserver = {
                    filetypes = { "javascript" },
                },
            }

            require("mason").setup()

            -- Ensure listed tools are installed
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format Lua code
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    -- LSP Saga Configuration
    {
        "nvimdev/lspsaga.nvim",
        opts = {
            lightbulb = {
                enable = false,
            },
            definition = {
                keys = {
                    quit = "q",
                    edit = "<Nop>",
                    vsplit = "<Nop>",
                    split = "<Nop>",
                    tabe = "<Nop>",
                },
            },
            outline = {
                layout = "float",
                win_position = "center",
                close_after_jump = true,
                keys = {
                    toggle_or_jump = "l",
                    jump = "h",
                },
            },
            rename = {
                auto_save = true,
                keys = {
                    quit = "<C-q>",
                },
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
