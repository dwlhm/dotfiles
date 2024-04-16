-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.o.termguicolor = true
vim.cmd('colorscheme catppuccin')
vim.g.flavour = 'mocha'

require('lualine').setup()

require('nvim-tree').setup()

local map = vim.keymap.set

-- keymap for using hjkl in insert mode (from nvChad configuration)
map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

-- split window
map("n", "<leader>v", "<cmd>vs<CR>", { desc = "Split window vertically" })
map("n", "<leader>h", "<cmd>sp<CR>", { desc = "Split window horizontally" })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree Focus window" })

-- lsp
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"biome", -- alternative to tsserver yang error disini
	},
	automatic_installation = true
})

local opts = { noremap = true, silent = true }

-- Basic diagnostic mappings, these will navigate to or display diagnostics
map('n', '<space>d', vim.diagnostic.open_float, opts)
map('n', '[d', vim.diagnostic.goto_prev, opts)
map('n', ']d', vim.diagnostic.goto_next, opts)
map('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings to magical LSP functions!
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)

	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gk', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
--for visualstudio lsps
capabilities.textDocument.completion.completionItem.snippetSupport = true
--activate lsps

require("mason-lspconfig").setup_handlers {
	-- default handler
	function(server_name)
		require("lspconfig")[server_name].setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}
	end,

	-- dedicated handler start here
}

-- Luasnip ---------------------------------------------------------------------
local luasnip = require("luasnip")
require("luasnip.loaders.from_lua").lazy_load()
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})

vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- CMP - Autocompletion
local cmp = require "cmp"
cmp.setup {
	snippet = {
    expand = function(args)
       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),

		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),

		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },

		{ name = 'buffer' },
		{ name = 'path' }
	},
}

-- Telescope
local telescope = require("telescope.builtin")
map("n", "<C-f>", telescope.find_files, {})
map("n", "<leader>fg", telescope.live_grep, {})
map("n", "<leader>fb", telescope.buffers, {})
map("n", "<leader>fh", telescope.help_tags, {})

-- telescope-ui-select 
-- This is your opts table
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }

    }
  }
}
require("telescope").load_extension("ui-select")

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- nvterm 
require("nvterm").setup()
map({ "n", "t" }, "<A-v>", function()
  require("nvterm.terminal").toggle("vertical")
end, { desc = "Terminal Toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvterm.terminal").toggle("horizontal")
end, { desc = "Terminal New horizontal term" })


map({ "n", "t" }, "<A-i>", function()
  require("nvterm.terminal").toggle("float")
end, { desc = "Terminal Toggle Floating term" })


map("t", "<ESC>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end, { desc = "Terminal Close term in terminal mode" })

-- dashboard-nvim
require("dashboard").setup({

    theme = 'hyper',
    config = {
      week_header = {
       enable = true,
      },
      shortcut = {
        { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
        {
          icon = ' ',
          icon_hl = '@variable',
          desc = 'Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' Apps',
          group = 'DiagnosticHint',
          action = 'Telescope app',
          key = 'a',
        },
        {
          desc = ' dotfiles',
          group = 'Number',
          action = 'Telescope dotfiles',
          key = 'd',
        },
      },
    },
  })
