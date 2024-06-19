return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            local harpoon = require("harpoon")

            harpoon:setup(opts)

            -- basic telescope configuration
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers")
                    .new({}, {
                        prompt_title = "Harpoon",
                        finder = require("telescope.finders").new_table({
                            results = file_paths,
                        }),
                        previewer = conf.file_previewer({}),
                        sorter = conf.generic_sorter({}),
                    })
                    :find()
            end


            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end)

            vim.keymap.set("n", "<leader><leader>", function()
                toggle_telescope(harpoon:list())
            end, { desc = "Open harpoon window" })

            vim.keymap.set("n", "<leader>E", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Open harpoon edit window" })

            vim.keymap.set("n", "<C-a>", function()
                harpoon:list():select(1)
            end)
            vim.keymap.set("n", "<C-s>", function()
                harpoon:list():select(2)
            end)
            vim.keymap.set("n", "<C-q>", function()
                harpoon:list():select(3)
            end)
            vim.keymap.set("n", "<C-w>", function()
                harpoon:list():select(4)
            end)
        end,
    },
    {
        "letieu/harpoon-lualine",
        dependencies = {
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
            },
        },
    },
}
