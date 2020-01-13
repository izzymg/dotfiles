" init.vim - izzy

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" Needed for 24 bit color terms
if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" Generic settings
syntax on
colorscheme onedark
filetype plugin indent on
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set number
set title
set encoding=utf-8

" Default 4 spaces
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent

" 2 spaces for web dev
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType js setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType svelte setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType vue setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Go must have 4-space tab
autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

" Go syntax highlighting
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1

" Keys
nmap <F2> :NERDTreeFind<CR>
nmap <F3> :FZF<CR>
