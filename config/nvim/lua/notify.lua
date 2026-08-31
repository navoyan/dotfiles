local M = {}

--- @param msg string
--- @param opts table|nil
function M.debug(msg, opts)
    vim.notify(msg, vim.log.levels.DEBUG, opts)
end

--- @param msg string
--- @param opts table|nil
function M.info(msg, opts)
    vim.notify(msg, vim.log.levels.INFO, opts)
end

--- @param msg string
--- @param opts table|nil
function M.warn(msg, opts)
    vim.notify(msg, vim.log.levels.WARN, opts)
end

--- @param msg string
--- @param opts table|nil
function M.error(msg, opts)
    vim.notify(msg, vim.log.levels.ERROR, opts)
end

return M
