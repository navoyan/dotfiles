local schedule, config = require("schedule"), require("config")
local map = vim.keymap.set

schedule.later(function()
    vim.pack.add({
        config.github("nvim-lua/plenary.nvim"),
        {
            src = config.github("olimorris/codecompanion.nvim"),
            version = vim.version.range("*"),
        },
    })

    local codecompanion = require("codecompanion")

    codecompanion.setup({
        opts = {
            log_level = "DEBUG", -- or "TRACE"
        },
        display = {
            diff = {
                enabled = true,
                provider = "split",
            },
        },
        adapters = {
            http = {
                anthropic = function()
                    return require("codecompanion.adapters").extend("anthropic", {
                        env = {
                            api_key = "cmd:rbw get claude_api_key",
                        },
                    })
                end,
            },
            acp = {
                claude_code = function()
                    return require("codecompanion.adapters").extend("claude_code", {
                        env = {
                            ANTHROPIC_API_KEY = "cmd:rbw get claude_code_api_key",
                        },
                    })
                end,
            },
        },
        interactions = {
            chat = {
                adapter = "anthropic",
                keymaps = {},
            },
        },
        -- interactions = {
        --     chat = {
        --         adapter = {
        --             name = "gemini_cli",
        --         },
        --     },
        -- },
        -- adapters = {
        --     acp = {
        --         gemini_cli = function()
        --             return require("codecompanion.adapters").extend("gemini_cli", {
        --                 defaults = {
        --                     auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
        --                 },
        --             })
        --         end,
        --     },
        -- },
    })

    local log = require("codecompanion.utils.log")
    local context_utils = require("codecompanion.utils.context")
    local constants = require("codecompanion.config").constants

    map({ "n", "v" }, "<Leader>ii", ":CodeCompanion")

    map("n", "<Leader>ic", "<Cmd>CodeCompanionChat Toggle<CR>")
    map({ "n", "v" }, "<Leader>iC", "<Cmd>CodeCompanionChat<CR>")

    map("v", "ga", function()
        local context = context_utils.get(vim.api.nvim_get_current_buf())
        local content = table.concat(context.lines, "\n")

        local chat = codecompanion.last_chat()

        if not chat then
            chat = codecompanion.chat()

            if not chat then
                return log:warn("Could not create chat buffer")
            end
        end

        chat:add_buf_message({
            role = constants.USER_ROLE,
            content = "Here is code from #{buffer}:"
                --
                .. "\n\n```"
                .. context.filetype
                .. "\n"
                .. content
                .. "\n```\n",
        })
        chat.ui:open()
    end)
end)
