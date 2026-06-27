return {
    "williamboman/mason.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
    },
    config = function()
        require("mason").setup()

        -- NOTE: There are a few language servers that I depend on, but that I don't want to use mason to install:
        -- gopls, rust-analyzer, clangd
        local ensure_installed = {
            "lua-language-server",
            "pyright",
            "json-lsp",
            "yaml-language-server",
            "robotframework-lsp",
            "bash-language-server",
            "dockerfile-language-server",
            "tombi",
        }

        vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
        end, {})

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        vim.lsp.config('*', {
            capabilities = capabilities,
        })

        -- NOTE: Unfortunately the names we use to install do not match the nvim-lspconfig names...
        vim.lsp.enable("pyright")
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("gopls")
        vim.lsp.enable("jsonls")
        vim.lsp.enable("yamlls")
        vim.lsp.enable("robotframework_ls")
        vim.lsp.enable("bashls")
        vim.lsp.enable("dockerls")
        vim.lsp.enable("tombi")
        vim.lsp.enable("clangd")
        vim.lsp.enable("rust_analyzer")

        vim.api.nvim_create_autocmd(
            'LspAttach',
            {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
                    vim.keymap.set('n', '<leader>jd', vim.lsp.buf.declaration)
                    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
                    vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover)
                end
            }
        )
    end,
}
