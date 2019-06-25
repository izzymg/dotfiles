call plug#begin('~/.local/share/nvim/plugged')
Plug 'dracula/vim'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent

""" Javascript 2 spaces
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab

""" Go tabs
autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

set wrap breakindent
set incsearch smartcase hlsearch
set encoding=utf-8
set title
set number

syntax on
color gruvbox

""" Allow term bg to come through
highlight Normal ctermbg=NONE

let NERDTreeShowHidden = 1
let g:go_highlight_structs = 1 
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
