# My_nvim_config

## Basic Introduction
This setup of nvim configuration is one for personal use, mainly for coding and taking notes.

## Plugins
1. wbthomason/packer.nvim
2. neoclide/coc.nvim
3. nvim-treesitter/nvim-treesitter
4. kylechui/nvim-surround
5. numToStr/Comment.nvim
6. ibhagwan/fzf-lua
7. nvim-telescope/telescope.nvim
8. nvim-lualine/lualine.nvim
9. anuvyklack/pretty-fold.nvim
10. neovim/nvim-lspconfig
11. liuchengxu/vista.vim
12. fgheng/winbar.nvim

## Configurations
All the configurations are in the one single configuration file which locates at lua/conf/init/lua

## Usage
To apply this setup to your neovim, clone this repo to /path/to/your/nvim (by default is $HOME/.config/nvim),and run :PackerInstall.
Make sure your connection is fine and everything should be ready.
All the language server will install automatically the first time you open the corresponding file.

## At Last
Not much work has done to prettify the editor.
Any suggestions, welcome issue or pull request.
