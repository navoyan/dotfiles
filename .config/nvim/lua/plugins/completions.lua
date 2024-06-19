return {
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    -- {
                    --   'rafamadriz/friendly-snippets',
                    --   config = function()
                    --     require('luasnip.loaders.from_vscode').lazy_load()
                    --   end,
                    -- },
                },
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            "onsails/lspkind.nvim",
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local compare = require("cmp.config.compare")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            luasnip.config.setup({})

            local types = require("cmp.types")

            local function deprioritize_snippet(entry1, entry2)
                if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
                    return false
                end
                if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
                    return true
                end
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-k>"] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ["<C-h>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ["<C-n>"] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-s-l> is similar, except moving you backwards.
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-g>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                }),

                sorting = {
                    priority_weight = 2,
                    comparators = {
                        deprioritize_snippet,
                        compare.offset,
                        compare.exact,
                        -- compare.scopes,
                        compare.score,
                        compare.recently_used,
                        compare.locality,
                        compare.kind,
                        -- compare.sort_text,
                        compare.length,
                        compare.order,
                    },
                },

                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    {
                        name = "lazydev",
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    },
                },

                -- window = {
                --     completion = cmp.config.window.bordered(),
                --     documentation = cmp.config.window.bordered(),
                -- },

                formatting = {
                    expandable_indicator = true,
                    fields = { "abbr", "menu", "kind" },
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        preset = "default",
                        symbol_map = {
                            Copilot = " ",
                            Text = "󰉿 ",
                            Method = "󰆧 ",
                            Function = "󰊕 ",
                            Constructor = " ",
                            Field = "󰜢 ",
                            Variable = "󰀫 ",
                            Class = "󰠱 ",
                            Interface = " ",
                            Module = " ",
                            Property = "󰜢 ",
                            Unit = "󰑭 ",
                            Value = "󰎠 ",
                            Enum = " ",
                            Keyword = "󰌋 ",
                            Snippet = " ",
                            Color = "󰏘 ",
                            File = "󰈙 ",
                            Reference = "󰈇 ",
                            Folder = "󰉋",
                            EnumMember = " ",
                            Constant = "󰏿 ",
                            Struct = "󰙅 ",
                            Event = " ",
                            Operator = "󰆕 ",
                            TypeParameter = "  ",
                        },
                        before = function(_, item)
                            item.menu = ""

                            return item
                        end,
                    }),
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        dependencies = { "hrsh7th/nvim-cmp" },
        opts = {
            -- panel = {
            --     enabled = false,
            -- },
            -- suggestion = {
            --     enabled = true,
            --     auto_trigger = false,
            --     keymap = {
            --         accept = "<M-h>",
            --         accept_word = false,
            --         accept_line = false,
            --         next = "<M-j>",
            --         prev = "<M-k>",
            --         dismiss = "<M-l>",
            --     },
            -- },
            suggestion = {
                auto_trigger = false,
                keymap = {
                    accept = "<C-h>",
                    accept_word = false,
                    accept_line = false,
                    next = "<C-b>",
                    prev = false,
                    dismiss = "<C-v>",
                },
            },
            panel = { enabled = false },
        },
    },
}
