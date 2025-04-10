return { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [']quote
        --  - ci'  - [C]hange [I]nside [']quote
        require("mini.ai").setup({ n_lines = 500 })

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require("mini.surround").setup()

        require("mini.move").setup({
            mappings = {
                -- Move visual selection in Visual mode
                left = "<C-S-h>",
                right = "<C-S-l>",
                down = "<C-S-j>",
                up = "<C-S-k>",

                -- Cove current line in Normal mode
                line_left = "<C-S-h>",
                line_right = "<C-S-l>",
                line_down = "<C-S-j>",
                line_up = "<C-S-k>",
            },
        })

        require("mini.bracketed").setup()

        -- require("mini.pairs").setup({
        -- 	modes = { insert = true, command = false, terminal = false },
        -- })

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
    end,
}
