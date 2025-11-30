return {
    {
        "saghen/blink.cmp",
        version = "*",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip", version = "v2.*" },
        },
        keys = {
            -- NOTE: fixes auto-accept behaviour
            { "<Esc>", "<C-c>", mode = { "c" } },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = "enter",
                ["<C-n>"] = { "show", "show_documentation", "hide_documentation" },
            },
            cmdline = {
                keymap = {
                    ["<Left>"] = {},
                    ["<Right>"] = {},
                    ["<Esc>"] = { "cancel", "fallback" },
                },
                completion = {
                    menu = { auto_show = true },
                    ghost_text = { enabled = false },
                    list = {
                        selection = {
                            preselect = false,
                        },
                    },
                },
            },

            completion = {
                ghost_text = { enabled = false },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                    auto_show = true,
                },
                list = {
                    selection = {
                        preselect = function()
                            return vim.bo.filetype ~= "liverename"
                        end,
                        auto_insert = false,
                    },
                },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = function()
                    if Util.is_multicursor_mode() then
                        return { "buffer" }
                    end

                    return { "lsp", "snippets", "path", "buffer" }
                end,

                per_filetype = {
                    lua = {
                        inherit_defaults = true,
                        "lazydev",
                    },
                },

                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority
                        score_offset = 100,
                    },
                },
            },

            snippets = { preset = "luasnip" },
        },
        opts_extend = { "sources.default" },
    },
}
