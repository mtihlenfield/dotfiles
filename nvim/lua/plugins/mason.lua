return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup()
        local mason_lspconfig = require("mason-lspconfig")
        local ensure_installed = {
            "lua-language-server",
            "pyright",
            "gopls",
            "json-lsp",
            "yaml-language-server",
            "robotframework-lsp",
            "bash-language-server",
            "dockerfile-language-server"
        }

        mason_lspconfig.setup({
            ensure_installed,
            automatic_installation = true,
            log_level = vim.log.levels.INFO,
        })

        local mason_tool_installer = require("mason-tool-installer")
        mason_tool_installer.setup({
            ensure_installed = {
                -- NOTE: These are packages that are not installable via apt. Mason makes it easier
                "golangci-lint", -- go
            },
        })

        vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
        end, {})

        local lspconfig = require("lspconfig")

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

        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        mason_lspconfig.setup_handlers({
            -- default handler for installed servers
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
        })
    end,
}
