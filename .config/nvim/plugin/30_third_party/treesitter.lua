local schedule, config = require("schedule"), require("config")

schedule.now_if_args(function()
    vim.pack.add({
        config.github("nvim-treesitter/nvim-treesitter"),
    })

    config.on_packchanged("nvim-treesitter", { "install", "update" }, vim.cmd.TSUpdate)

    local treesitter = require("nvim-treesitter")

    ---@type table<string, string>
    local installed_for_fts = {}

    ---@param lang string
    local function mark_fts_as_installed_for_lang(lang)
        local fts = vim.treesitter.language.get_filetypes(lang)
        for _, ft in ipairs(fts) do
            installed_for_fts[ft] = lang
        end
    end

    for _, lang in ipairs(treesitter.get_installed("parsers")) do
        mark_fts_as_installed_for_lang(lang)
    end

    local available_parsers = require("nvim-treesitter.parsers")

    config.new_autocmd("FileType", "*", function(event)
        local buf = event.buf
        local ft = event.match

        local installed_lang = installed_for_fts[ft]
        if installed_lang then
            vim.treesitter.start(buf, installed_lang)
            return
        end

        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not available_parsers[lang] then
            return
        end

        treesitter.install(lang):await(function()
            vim.treesitter.start(buf, lang)
            mark_fts_as_installed_for_lang(lang)
        end)
    end)
end)
