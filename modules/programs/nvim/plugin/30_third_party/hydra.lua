local schedule, config = require("schedule"), require("config")

schedule.later(function()
    vim.pack.add({
        config.github("nvimtools/hydra.nvim"),
    })

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
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk(gitsigns_direction, { wrap = true, navigation_message = false })
            vim.wait(5)
        end
    end

    local jumps = {
        K = MiniBracketed.comment,
        X = MiniBracketed.conflict,
        D = MiniBracketed.diagnostic,
        J = MiniBracketed.jump,
        Q = MiniBracketed.quickfix,
        C = nav_hunk,
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

    local forward_jumps = vim.iter(jumps)
        :map(function(key, jump)
            return {
                key,
                forward(jump),
            }
        end)
        :totable()

    local backward_jumps = vim.iter(jumps)
        :map(function(key, jump)
            return {
                key,
                backward(jump),
            }
        end)
        :totable()

    local function hydra_config()
        return {
            color = "pink",
            on_enter = function()
                vim.bo.modifiable = false
                vim.schedule(vim.cmd.redrawstatus)
            end,
            on_exit = function()
                vim.schedule(vim.cmd.redrawstatus)
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
end)
