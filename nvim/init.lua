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
set.expandtab = false
set.termguicolors = true
set.rtp:prepend(lazypath)
set.number = false
set.autoindent = true

vim.keymap.set('', '<MiddleMouse>', '<Nop>', { remap = false })

local plugins = {
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{ 'nvim-telescope/telescope-dap.nvim' },
	{ "nvim-treesitter/nvim-treesitter" },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"EdenEast/nightfox.nvim", 
		lazy = false, 
		priority = 1000, 
	},
	{ 'lewis6991/gitsigns.nvim' },
	{  "freddiehaddad/feline.nvim" },	
	{ "nvim-tree/nvim-web-devicons" },
	{ 'mfussenegger/nvim-dap' },
	{ "folke/lazydev.nvim" },
	{
		"igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
	},
	{
		"mason-org/mason.nvim",
		opts = {}
	}
}
require("lazy").setup(plugins, opts)
require("lazydev").setup({
  library = { "nvim-dap-ui" },
})
vim.g.mapleader = " "
vim.opt.signcolumn = 'yes'
local cmp = require("cmp")

cmp.setup({
	mapping = cmp.mapping.preset.insert{
	  ['<C-n>'] = cmp.mapping.select_next_item(),
	  ['<C-p>'] = cmp.mapping.select_prev_item(),
	  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-f>'] = cmp.mapping.scroll_docs(4),
	  ['<C-Enter>'] = cmp.mapping.confirm { select = true },
	  ['<C-Space>'] = cmp.mapping.complete {},
	  ['<C-l>'] = cmp.mapping(function()
		if luasnip.expand_or_locally_jumpable() then
		  luasnip.expand_or_jump()
		end
	  end, { 'i', 's' }),
	  ['<C-h>'] = cmp.mapping(function()
		if luasnip.locally_jumpable(-1) then
		  luasnip.jump(-1)
		end
	  end, { 'i', 's' }),
	},
	sources = {
	  {
		name = 'lazydev',
		group_index = 0,
	  },
	  { name = 'nvim_lsp' },
	},
})


local lspconfig_defaults = vim.lsp.config('*', {
	capabilities = {
		require('cmp_nvim_lsp').default_capabilities()
	}
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
})

-- C++
vim.lsp.enable('clangd')

-- JS
local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = { 
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.enable('vue_ls')

-- Rust
vim.lsp.enable('rust_analyzer')


--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "rust",
--  callback = function()
--    vim.opt_local.makeprg = "cargo"
--    vim.opt_local.errorformat = [[%f:%l:%c: %m]]
--  end,
--})

-- Run program keybind
vim.keymap.set('n', '<leader>r', function()
	if vim.bo.filetype == 'rust' then
		vim.cmd('botright 15split | terminal cargo run')
		vim.cmd('startinsert')
	end
end, { desc = "Run program" })

-- Git
require('gitsigns').setup()

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

local builtin = require('telescope.builtin')

require('telescope').setup{
      pickers = {
        colorscheme = {
          enable_preview = true
        }
      }
}
require('telescope').load_extension('dap')

vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
vim.keymap.set('n', '<leader>kn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>kf', vim.lsp.buf.format, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

-- Color
vim.cmd.colorscheme "duskfox"
require("catppuccin").setup({
	flavour = "macchiato",
	integrations = {
		gitsigns = true,
		treesitter = true,
	}
})


-- Airline bar - catppuccin feline integration might be dead?
--local ctp_feline = require('catppuccin.groups.integrations.feline')
--ctp_feline.setup({
--})

require("feline").setup({
    -- components = ctp_feline.get()
})

require('feline').statuscolumn.setup()
require('feline').winbar.setup()

