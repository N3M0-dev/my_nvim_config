"===
"=== Basic Settings
"===

set number
set relativenumber
set scrolloff=5
set softtabstop=4
set shiftwidth=4
set autoindent
lua require('plugins')
lua require('conf')
filetype plugin indent on
syntax on
syntax enable

let g:vim_markdown_math = 1
set conceallevel=2
let g:tex_conceal="abdgm"
hi conceal ctermbg=none
