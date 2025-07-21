return {
    {
        "echasnovski/mini.files",
        lazy = true,
        keys = {
            {
                "<leader>e",
                function()
                    local current_buf = vim.api.nvim_buf_get_name(0)
                    MiniFiles.open(current_buf)
                    MiniFiles.reveal_cwd()
                end,
                desc = "[E]xplore MiniFiles",
            },
        },
        opts = {
            options = {
                -- Whether to delete permanently or move into module-specific trash
                permanent_delete = false,
                -- Whether to use for editing directories
                use_as_default_explorer = true,
            },
            mappings = {
                close = "q",
                go_in = "l",
                go_in_plus = "<Enter>",
                go_out = "h",
                go_out_plus = "H",
                reset = "=",
                reveal_cwd = "@",
                show_help = "g?",
                synchronize = "Q",
                trim_left = "<",
                trim_right = ">",
            },
            windows = {
                -- Maximum number of windows to show side by side
                max_number = math.huge,
                -- Whether to show preview of file/directory under cursor
                preview = true,
                -- Width of focused window
                width_focus = 50,
                -- Width of non-focused window
                width_nofocus = 15,
                -- Width of preview window
                width_preview = 25,
            },
        },
    },
    {
        "cbochs/grapple.nvim",
        dependencies = { "echasnovski/mini.icons" },
        keys = {
            { ";", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
        },
        config = function()
            local Grapple = require("grapple")
            local Settings = require("grapple.settings")

            local default_settings = Settings:new()

            Grapple.setup({
                icons = true,
                quick_select = "123456789",
                tag_hook = function(window)
                    window:map("n", "a", function()
                        window:close()
                        Grapple.toggle()
                        Grapple.open_tags()
                    end, { desc = "Toggle tag for current file" })

                    default_settings.tag_hook(window)
                end,
            })
        end,
    },
    {
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        build = "./kitty/install-kittens.bash",
        config = function()
            local splits = require("smart-splits")

            -- creating vim splits
            vim.keymap.set("n", "<leader>sh", "<cmd>vertical leftabove split<cr>")
            vim.keymap.set("n", "<leader>sj", "<cmd>horizontal belowright split<cr>")
            vim.keymap.set("n", "<leader>sk", "<cmd>horizontal topleft split<cr>")
            vim.keymap.set("n", "<leader>sl", "<cmd>vertical rightbelow split<cr>")
            -- moving between splits
            vim.keymap.set("n", "<M-h>", splits.move_cursor_left)
            vim.keymap.set("n", "<M-j>", splits.move_cursor_down)
            vim.keymap.set("n", "<M-k>", splits.move_cursor_up)
            vim.keymap.set("n", "<M-l>", splits.move_cursor_right)
            -- resizing splits
            vim.keymap.set("n", "<M-S-h>", splits.resize_left)
            vim.keymap.set("n", "<M-S-j>", splits.resize_down)
            vim.keymap.set("n", "<M-S-k>", splits.resize_up)
            vim.keymap.set("n", "<M-S-l>", splits.resize_right)
        end,
    },
    {
        "nvimtools/hydra.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "echasnovski/mini.bracketed",
        },
        lazy = false,
        config = function()
            local Hydra = require("hydra")
            Hydra.setup({
                hint = false,
            })

            local gitsigns = require("gitsigns")

            local function nav_hunk(direction)
                local mapping = {
                    forward = { "next", "]" },
                    backward = { "prev", "[" },
                }

                local gitsigns_direction, bracket = mapping[direction][1], mapping[direction][2]

                if vim.wo.diff then
                    vim.cmd.normal({ bracket .. "c", bang = true })
                else
                    gitsigns.nav_hunk(gitsigns_direction, { wrap = true, navigation_message = false })
                    vim.wait(5)
                end
            end

            local jumps = {
                k = MiniBracketed.comment,
                x = MiniBracketed.conflict,
                d = MiniBracketed.diagnostic,
                j = MiniBracketed.jump,
                q = MiniBracketed.quickfix,
                c = nav_hunk,
            }

            local function forward(jump)
                return function()
                    return jump("forward")
                end
            end

            local function backward(jump)
                return function()
                    return jump("backward")
                end
            end

            local function head_opts()
                return {
                    desc = false,
                }
            end

            local forward_jumps = {}
            for key, jump in pairs(jumps) do
                table.insert(forward_jumps, {
                    key,
                    forward(jump),
                    head_opts(),
                })
                table.insert(forward_jumps, {
                    string.upper(key),
                    backward(jump),
                    head_opts(),
                })
            end

            local backward_jumps = {}
            for key, jump in pairs(jumps) do
                table.insert(backward_jumps, {
                    key,
                    backward(jump),
                    head_opts(),
                })
                table.insert(backward_jumps, {
                    string.upper(key),
                    forward(jump),
                    head_opts(),
                })
            end

            local lualine = require("lualine")

            local function hydra_config()
                return {
                    color = "pink",
                    on_enter = function()
                        vim.bo.modifiable = false
                        lualine.refresh({ place = { "statusline" } })
                    end,
                    on_exit = function()
                        lualine.refresh({ place = { "statusline" } })
                    end,
                }
            end

            -- Forward
            Hydra({
                body = "]",
                mode = "n",
                config = hydra_config(),
                heads = forward_jumps,
            })

            -- Backward
            Hydra({
                body = "[",
                mode = "n",
                config = hydra_config(),
                heads = backward_jumps,
            })
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        enabled = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
            { "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
            { "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
            { "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
        },
    },
}
