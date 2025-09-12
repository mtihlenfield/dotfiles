-- nvim configuration options

-- color scheme
vim.cmd("colorscheme nord")
vim.opt.termguicolors = true
vim.opt.background = "dark"


-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- disable default tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- enable mouse support
vim.opt.mouse = "a"

-- spaces and tabs
vim.opt.tabstop = 4      -- 4 spaces for tabs
vim.opt.shiftwidth = 4   -- 4 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- spellcheck
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- virtual_text = true makes the diagnostic messages show up next to the lines
-- where the errors are in the text
vim.diagnostic.config({ virtual_text = true })
