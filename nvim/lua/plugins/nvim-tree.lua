return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {}

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>to", "<cmd>NvimTreeOpen<cr>")
        keymap.set("n", "<leader>tq", "<cmd>NvimTreeClose<cr>")
        keymap.set("n", "<leader>tr", "<cmd>NvimTreeRefresh<cr>")
    end,
}
