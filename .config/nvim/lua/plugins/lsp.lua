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
                gopls = {},
                basedpyright = {},
                ts_ls = {
                    filetypes = { "javascript" },
                },
                helm_ls = {},
                yamlls = {},
            },
        },
        config = function(_, opts)
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

                    local function with_inline_preview(picker_fn)
                        return function()
                            picker_fn({ layout = { preset = "vscode", preview = "main" } })
                        end
                    end

                    local picker = Snacks.picker

                    -- Jump to the definition of the word under the cursor.
                    map("gd", with_inline_preview(picker.lsp_definitions), "[G]oto [D]efinition")

                    -- Find references for the word under the cursor.
                    map("gr", with_inline_preview(picker.lsp_references), "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under the cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", with_inline_preview(picker.lsp_implementations), "[G]oto [I]mplementation")

                    -- Jump to the type of the symbol under the cursor.
                    map("gy", with_inline_preview(picker.lsp_type_definitions), "[G]oto T[y]pe Definition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>sd", with_inline_preview(picker.lsp_symbols), "[S]ymbols in [D]ocument")

                    -- Fuzzy find all the symbols in your current workspace.
                    map("<leader>sw", with_inline_preview(picker.lsp_workspace_symbols), "[S]ymbols in [W]orkspace")

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

                    -- Opens a popup that displays documentation about the word under the cursor
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- This is not Goto Definition, this is Goto Declaration.
                    --    For example, in C this would take you to the header.
                    map("<leader>D", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
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
