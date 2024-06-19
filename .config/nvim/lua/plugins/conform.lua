return { -- Autoformat
    "stevearc/conform.nvim",
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>l",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        notify_on_error = true,
        -- format_on_save = function(bufnr)
        -- 	-- Disable "format_on_save lsp_fallback" for languages that don't
        -- 	-- have a well standardized coding style. You can add additional
        -- 	-- languages here or re-enable it for the disabled ones.
        -- 	local disable_filetypes = { c = true, cpp = true }
        -- 	return {
        -- 		timeout_ms = 500,
        -- 		lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        -- 	}
        -- end,
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            rust = { "rustfmt" },

            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            -- javascript = { { "prettierd", "prettier" } },
        },
    },
}
