--- Scheduling functions for two-stage config execution
--- Stripped from `mini.deps`

local M = {}
local H = {}

-- The state of the scheduling
H.state = {
    -- Whether finish of `now()` or `later()` is already scheduled
    finish_is_scheduled = false,

    -- Callback queue for `later()`
    later_callback_queue = {},

    -- Errors during execution of `now()` or `later()`
    exec_errors = {},

    -- Git version
    git_version = nil,
}

--- Execute function now
---
--- Safely execute function immediately. Errors are shown with `vim.notify()`
--- later, after all queued functions (including with `later()`)
--- are executed, thus not blocking execution of next code in file.
---
--- Assumed to be used as a first step during two-stage config execution to
--- load plugins immediately during startup.
---
---@param f fun() Callable to execute.
function M.now(f)
    local ok, err = pcall(f)
    if not ok then
        table.insert(H.state.exec_errors, err)
    end
    H.schedule_finish()
end

--- Execute function later
---
--- Queue function to be safely executed later without blocking execution of
--- next code in file. All queued functions are guaranteed to be executed in
--- order they were added.
--- Errors are shown with `vim.notify()` after all queued functions are executed.
---
--- Assumed to be used as a second step during two-stage config execution to
--- load plugins "lazily" after startup.
---
---@param f fun() Callable to execute.
function M.later(f)
    table.insert(H.state.later_callback_queue, f)
    H.schedule_finish()
end

--- `now`, if there is a file in the argument list,
--- otherwise later
M.now_if_args = vim.fn.argc(-1) > 0 and M.now or M.later

function H.schedule_finish()
    if H.state.finish_is_scheduled then
        return
    end
    vim.schedule(H.finish)
    H.state.finish_is_scheduled = true
end

function H.finish()
    local timer, step_delay = vim.loop.new_timer(), 1

    if timer == nil then
        return
    end

    local f
    f = vim.schedule_wrap(function()
        local callback = H.state.later_callback_queue[1]
        if callback == nil then
            H.state.finish_is_scheduled, H.state.later_callback_queue = false, {}
            H.report_errors()
            return
        end

        table.remove(H.state.later_callback_queue, 1)
        M.now(callback)
        timer:start(step_delay, 0, f)
    end)
    timer:start(step_delay, 0, f)
end

function H.report_errors()
    if #H.state.exec_errors == 0 then
        return
    end
    local error_lines = table.concat(H.state.exec_errors, "\n\n")
    H.state.exec_errors = {}
    H.notify("There were errors during two-stage execution:\n\n" .. error_lines, "ERROR")
end

H.notify = vim.schedule_wrap(function(msg, level)
    vim.notify(msg, vim.log.levels[level])
    vim.cmd("redraw")
end)

return M
