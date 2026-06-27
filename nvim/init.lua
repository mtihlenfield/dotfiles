-- Temporary fix for legacy nvim-treesitter on Neovim 0.12+.
-- Eventually I probably need to switch to treesitter's main branch (currently on master),
-- but I've found some plugins don't work with it
local original_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
    -- If Neovim 0.12 passes an array/table of nodes instead of a single node
    if type(node) == "table" and node[1] ~= nil then
        node = node[1]
    end
    return original_get_node_text(node, source, opts)
end

require("config")
