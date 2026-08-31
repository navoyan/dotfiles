local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvim-mini/mini.extra"),
        config.github("nvim-mini/mini.ai"),
    })

    local ai = require("mini.ai")
    local extra = require("mini.extra")

    ai.setup({
        custom_textobjects = {
            g = extra.gen_ai_spec.buffer(),
            i = extra.gen_ai_spec.indent(),
            e = extra.gen_ai_spec.line(),
            x = extra.gen_ai_spec.number(),
            f = ai.gen_spec.function_call({
                name_pattern = "[%w_%.:!]",
            }),
        },
    })
end)
