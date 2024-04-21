local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
local set = vim.opt
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.termguicolors = true
set.rtp:prepend(lazypath)
set.number = true
set.autoindent = true

vim.keymap.set('', '<MiddleMouse>', '<Nop>', { remap = false })

local plugins = {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{ "nvim-treesitter/nvim-treesitter" },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"EdenEast/nightfox.nvim", 
		lazy = false, 
		priority = 1000, 
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
	},
	{  "freddiehaddad/feline.nvim" },	
	{ "nvim-tree/nvim-web-devicons" },

}
require("lazy").setup(plugins, opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
vim.keymap.set('n', '<leader>kk', function() vim.cmd.RustLsp{ 'hover', 'actions' } end, opts)
vim.keymap.set('n', '<leader>kn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>kf', vim.lsp.buf.format, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

vim.cmd.colorscheme "catppuccin"
vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
		local opts = { buffer = bufnr }
		-- completions
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		-- key
	end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}

local ctp_feline = require('catppuccin.groups.integrations.feline')

ctp_feline.setup()

require("feline").setup({
    components = ctp_feline.get(),
})

