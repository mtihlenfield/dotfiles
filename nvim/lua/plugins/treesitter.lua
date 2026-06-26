return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")

        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            sync_install = true,
            -- ensure these language parsers are installed
            ensure_installed = {
                "python",
                "go",
                "gomod",
                "gosum",
                "json",
                "yaml",
                "markdown",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "c",
                "cmake",
                "make",
                "cpp",
                "robot",
                "asm",
                "rust",
                "toml",
                "scheme",
                "csv",
                "html",
                "css",
                "javascript",
                "diff",
                "linkerscript",
                "nginx",
                "sql",
                "typescript",
                "xml"
            },
        })
    end,
}
