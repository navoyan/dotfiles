local schedule, config = require("schedule"), require("config")

schedule.now_if_args(function()
    vim.pack.add({
        {
            src = config.github("nvim-treesitter/nvim-treesitter"),
            version = "master",
        },
    })

    config.on_packchanged("nvim-treesitter", { "install", "update" }, vim.cmd.TSUpdate)

    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "rust",
            "python",
            "bash",
            "c",
            "html",
            "lua",
            "luadoc",
            "markdown",
            "vim",
            "vimdoc",
        },
        auto_install = true,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            -- When experiencing weird indenting issues, the language needs to be added
            -- to the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { "ruby" },
        },
        indent = { enable = false, disable = { "ruby" } },
    })

    vim.filetype.add({
        extension = {
            gotmpl = "gotmpl",
        },
        pattern = {
            [".*/templates/.*%.tpl"] = "helm",
            [".*/templates/.*%.ya?ml"] = "helm",
            ["helmfile.*%.ya?ml"] = "helm",
        },
    })
end)
