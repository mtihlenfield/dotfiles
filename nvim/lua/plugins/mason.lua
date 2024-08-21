return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} }
    },
    config = function()
        require("mason").setup()
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "gopls",
                "jsonls",
                "yamlls",
                "robotframework_ls",
                "bashls",
                "dockerls"
            },
            automatic_installation = false,
        })

        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
        lspconfig.pyright.setup({})
        lspconfig.gopls.setup({})
        lspconfig.jsonls.setup({})
        lspconfig.yamlls.setup({})
        lspconfig.robotframework_ls.setup({})
        lspconfig.bashls.setup({})
        lspconfig.dockerls.setup({})

        vim.api.nvim_create_autocmd(
            'LspAttach',
            {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- TODO: set up better keymaps - don't like these
                    -- TODO: Also integrate with telescope for things like references
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
                    vim.keymap.set('n', '<leader>jd', vim.lsp.buf.declaration)
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
