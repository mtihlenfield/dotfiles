return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local actions_layout = require("telescope.actions.layout")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["?"] = actions_layout.toggle_preview,
                        },
                    }
                }
            })

            telescope.load_extension("fzf")

            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
            -- I couldn't get the config option for disabling previews to work...
            vim.keymap.set("n", "<leader>fb",
                "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({ previewer = false })<CR>")
            vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>")
            vim.keymap.set("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>")
            vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")
            vim.keymap.set("n", "<leader>fc", "<cmd>Telescope lsp_incoming_calls<cr>")
            vim.keymap.set("n", "<leader>fC", "<cmd>Telescope lsp_outgoing_calls<cr>")
            vim.keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>")
            vim.keymap.set("n", "<leader>ft", "<cmd>Telescope lsp_type_definitions<cr>")
        end,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").load_extension("ui-select")
        end
    }
}
