vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.o.termguicolor = true
vim.cmd('colorscheme catppuccin')
vim.g.flavour = 'mocha'

require('lualine').setup()

require('nvim-tree').setup()

local map = vim.keymap.set

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree Focus window" })
