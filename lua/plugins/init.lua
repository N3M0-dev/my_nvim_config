return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use { 'neoclide/coc.nvim', branch = 'release' }
	use { 'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	})
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use { 'ibhagwan/fzf-lua',
		-- optional for icon support
		requires = { 'nvim-tree/nvim-web-devicons' }
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use { 'anuvyklack/pretty-fold.nvim',
		config = function()
			require('pretty-fold').setup()
		end
	}
	use 'neovim/nvim-lspconfig'
	use 'liuchengxu/vista.vim'
	use 'fgheng/winbar.nvim'
	use 'lervag/vimtex'
	-- install without yarn or npm
	use({
		"iamcco/markdown-preview.nvim",
		run = function() vim.fn["mkdp#util#install"]() end,
	})

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	})
	use 'dhruvasagar/vim-table-mode'
	use { 'godlygeek/tabular' }
	use { 'preservim/vim-markdown' }
	use 'KeitaNakamura/tex-conceal.vim'
end)
