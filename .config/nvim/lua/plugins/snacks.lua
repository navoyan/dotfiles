return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
        },
        {
            "<leader>go",
            function()
                Snacks.gitbrowse()
            end,
            mode = { "n", "v" },
        },
        {
            "<leader>gb",
            function()
                Snacks.gitbrowse({ what = "branch" })
            end,
        },
    },
    opts = {
        gitbrowse = {
            remote_patterns = {
                { "^ssh://git@git%.(.+):(.+)/main/(.+)%.git$", "https://space.%1:%2/p/main/repositories/%3" },
                { "^(https?://.*)%.git$", "%1" },
                { "^git@(.+):(.+)%.git$", "https://%1/%2" },
                { "^git@(.+):(.+)$", "https://%1/%2" },
                { "^git@(.+)/(.+)$", "https://%1/%2" },
                { "^ssh://git@(.*)$", "https://%1" },
                { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
                { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
                { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
                { "^https://%w*@(.*)", "https://%1" },
                { "^git@(.*)", "https://%1" },
                { ":%d+", "" },
                { "%.git$", "" },
            },
            url_patterns = {
                ["space%.(.+)"] = {
                    branch = "/commits?query=head:refs/heads/{branch}&tab=changes",
                    file = function(fields)
                        return "/files/dev/"
                            .. fields.file
                            .. "?tab=source&line="
                            .. fields.line_start
                            .. "&lines-count="
                            .. fields.line_end - fields.line_start + 1
                    end,
                    commit = "/revision/{commit}",
                },
                ["github%.com"] = {
                    branch = "/tree/{branch}",
                    file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                    commit = "/commit/{commit}",
                },
                ["gitlab%.com"] = {
                    branch = "/-/tree/{branch}",
                    file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
                    commit = "/-/commit/{commit}",
                },
            },
        },
    },
}
