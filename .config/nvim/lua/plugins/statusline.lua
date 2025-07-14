local function norm_path(path)
    if path:sub(1, 1) == "~" then
        local home = vim.uv.os_homedir() or ""
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
            home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
    end
    path = path:gsub("\\", "/"):gsub("/+", "/")
    return path:sub(-1) == "/" and path:sub(1, -2) or path
end

local function real_path(path)
    if path == "" or path == nil then
        return nil
    end
    path = vim.uv.fs_realpath(path) or path
    return norm_path(path)
end

local function format_component(component, text, hl_group)
    text = text:gsub("%%", "%%%%")
    if not hl_group or hl_group == "" then
        return text
    end
    ---@type table<string, string>
    component.hl_cache = component.hl_cache or {}
    local lualine_hl_group = component.hl_cache[hl_group]
    if not lualine_hl_group then
        local utils = require("lualine.utils.utils")
        ---@type string[]
        local gui = vim.tbl_filter(function(x)
            return x
        end, {
            utils.extract_highlight_colors(hl_group, "bold") and "bold",
            utils.extract_highlight_colors(hl_group, "italic") and "italic",
        })

        lualine_hl_group = component:create_hl({
            fg = utils.extract_highlight_colors(hl_group, "fg"),
            gui = #gui > 0 and table.concat(gui, ",") or nil,
        }, "LV_" .. hl_group) --[[@as string]]
        component.hl_cache[hl_group] = lualine_hl_group
    end
    return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

-- NOTE: adapted from `LazyVim.lualine.pretty_path`
local function pretty_path(self, opts)
    local modified_hl = "MatchParen"
    local filename_hl = "Bold"
    local readonly_icon = " 󰌾"
    local max_parts_in_shortened = 3

    local path = vim.fn.expand("%:p")

    if path == "" then
        return ""
    end

    path = norm_path(path)
    local cwd = real_path(vim.uv.cwd()) or ""

    if path:find(cwd, 1, true) == 1 then
        path = path:sub(#cwd + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    if opts.full_path or max_parts_in_shortened <= 0 then
        parts = parts
    elseif #parts > max_parts_in_shortened then
        parts = { parts[1], parts[2], "…", unpack(parts, #parts - max_parts_in_shortened + 3, #parts) }
    end

    if modified_hl and vim.bo.modified then
        parts[#parts] = format_component(self, parts[#parts], modified_hl)
    else
        parts[#parts] = format_component(self, parts[#parts], filename_hl)
    end

    local dir = ""
    if #parts > 1 then
        dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
        dir = dir .. sep
    end

    local readonly = ""
    if vim.bo.readonly then
        readonly = format_component(self, readonly_icon, modified_hl)
    end

    local result = dir .. parts[#parts] .. readonly

    return result
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "echasnovski/mini.icons",
            "SmiteshP/nvim-navic",
            "nvimtools/hydra.nvim",
        },
        config = function()
            local lualine = require("lualine")
            local colors = require("tokyonight.colors").setup()
            local hydra = require("hydra.statusline")

            local map = vim.keymap.set

            local navic_enabled = true
            map("n", "<leader>cp", function()
                navic_enabled = not navic_enabled
                lualine.refresh({ place = { "statusline" } })
            end, { desc = "Toggle [C]ode [P]ath (Navic)" })

            lualine.setup({
                options = {
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { -- Filetypes to disable lualine for.
                        statusline = { "no-neck-pain", "snacks_dashboard" }, -- only ignores the ft for statusline.
                        winbar = {}, -- only ignores the ft for winbar.
                    },
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(mode)
                                return hydra.is_active() and "HYDRA" or mode
                            end,
                            color = function()
                                return { bg = hydra.is_active() and colors.red or nil }
                            end,
                        },
                    },
                    lualine_b = {
                        "branch",
                    },
                    lualine_c = {
                        {
                            "filetype",
                            icon_only = true,
                            padding = { left = 1, right = 0 },
                            separator = "",
                        },
                        {
                            function(self)
                                return pretty_path(self, { full_path = not navic_enabled })
                            end,
                            padding = { left = 0, right = 1 },
                        },
                        {
                            "navic",
                            cond = function()
                                return navic_enabled
                            end,
                            navic_opts = {
                                highlight = true,
                                separator = " ",
                            },
                        },
                    },
                    lualine_x = {
                        "diagnostics",
                        {
                            "diff",
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        opts = {
            lsp = {
                auto_attach = true,
            },
        },
    },
}
