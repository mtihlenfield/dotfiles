return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            telescope.load_extension("fzf")

            -- TODO Change this back to using ;
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
            vim.keymap.set("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
        end,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").load_extension("ui-select")
        end
    }
}
