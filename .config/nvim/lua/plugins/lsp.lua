return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            { "williamboman/mason.nvim", opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            "saghen/blink.cmp",

            "nvim-lua/plenary.nvim",

            "j-hui/fidget.nvim",
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

                    local function with_preview(picker_fn)
                        return function()
                            picker_fn({ layout = { preset = "vscode", preview = "main" } })
                        end
                    end

                    local picker = Snacks.picker

                    -- Jump to the definition of the word under the cursor.
                    map("gd", with_preview(picker.lsp_definitions), "[G]oto [D]efinition")

                    -- Find references for the word under the cursor.
                    map("gr", with_preview(picker.lsp_references), "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under the cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", with_preview(picker.lsp_implementations), "[G]oto [I]mplementation")

                    -- Jump to the type of the symbol under the cursor.
                    map("gy", with_preview(picker.lsp_type_definitions), "[G]oto T[y]pe Definition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>sd", with_preview(picker.lsp_symbols), "[S]ymbols in [D]ocument")

                    -- Fuzzy find all the symbols in your current workspace.
                    map("<leader>sw", with_preview(picker.lsp_workspace_symbols), "[S]ymbols in [W]orkspace")

                    -- Rename the variable under the cursor.
                    --  Most Language Servers support renaming across files, etc.
                    vim.keymap.set("n", "<leader>rn", function()
                        return ":IncRename " .. vim.fn.expand("<cword>")
                    end, { expr = true, buffer = event.buf, desc = "LSP: [R]e[n]ame" })

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
                    map("<leader>dp", vim.diagnostic.goto_prev, "[D]iagnostics: jump to previous")

                    -- Opens a popup that displays documentation about the word under the cursor
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- This is not Goto Definition, this is Goto Declaration.
                    --    For example, in C this would take you to the header.
                    map("<leader>D", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                end,
            })

            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            local servers = {
                basedpyright = {},
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
                ts_ls = {
                    filetypes = { "javascript" },
                },
            }

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
                        local capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
