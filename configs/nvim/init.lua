vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.o.termguicolor = true
vim.cmd('colorscheme catppuccin')
vim.g.flavour = 'mocha'

require('lualine').setup()
