-- ||
-- || Global Declarations
-- ||
local keyset = vim.keymap.set

-- ||
-- || Basic Configurations
-- ||
vim.g.mapleader = " "


-- ||
-- || Nvim-treesitter Configurations
-- ||
require('nvim-treesitter.configs').setup {
	ensure_installed = {
		"c",
		"cpp",
		"rust",
		"go",
		"cuda",
		"html",
		"markdown",
		"cmake",
		"python",
		"comment",
		"latex",
		"java",
		"lua",
		"vim",
		"help" },
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = { "latex", "markdown" },
		additional_vim_regex_highlighting = false,
	}
}




-- ||
-- || Coc Example Lua Configurations
-- ||

--**********
--Extensions
--**********
--using the global variable g:coc_global_extensions
--vim.g.coc_global_extensions=['sometingA','sometingB']
--vim.g.coc_global_extensions = ['coc-clangd', 'coc-go', 'coc-lua', 'coc-rust-analyzer', 'coc-pylsp']
vim.g.coc_global_extensions = {
	'coc-clangd',
	'coc-go',
	'coc-sumneko-lua',
	'coc-rust-analyzer',
	'coc-json',
	'coc-pyright',
	'coc-ltex',
	'coc-snippets',
	'coc-vimlsp',
	'coc-pairs',
}
--原表(maybe this name)in lua should be surrounded by "{" and "}"


--to check latex, configuration required by coc-ltex
vim.g.coc_filetype_map = "'tex':'latex'"


-- Some servers have issues with backup files, see #649
-- According to bilibili TheCW, no issues ever met, and issue #649 has been closed.
-- The following two is decommented by default!
-- vim.opt.backup = false
-- vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
-- default 300, changed to 100 following TheCW
vim.opt.updatetime = 100

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
-- keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })

keyset("n", "gr", "<Plug>(coc-references)", { silent = true })


-- Use K to show documentation in preview window
function _G.show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })


-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold"
})



-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })


-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })


-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
	group = "CocGroup",
	pattern = "typescript,json",
	command = "setl formatexpr=CocAction('formatSelected')",
	desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
	group = "CocGroup",
	pattern = "CocJumpPlaceholder",
	command = "call CocActionAsync('showSignatureHelp')",
	desc = "Update signature help on jump placeholder"
})

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = { silent = true, nowait = true }
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply code actions affect whole buffer.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Remap keys for applying codeActions to the current buffer
keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
--now coc-symbol-dline has replaced it due to its VERBOSITY!!
-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true, expr = true }
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>",
	'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>",
	'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })


-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
-- Show all diagnostics
keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)


-- ||
-- || Lualine Configurations (Now default copied from Github Official)
-- ||

string.replace = function(s, pattern, repl)
	local i, j = string.find(s, pattern, 1, true)
	if i and j then
		local ret = {}
		local start = 1
		while i and j do
			table.insert(ret, string.sub(s, start, i - 1))
			table.insert(ret, repl)
			start = j + 1
			i, j = string.find(s, pattern, start, true)
		end
		table.insert(ret, string.sub(s, start))
		return table.concat(ret)
	end
	return s
end

--function using nvim-treesitter to show in which code structure the curosr is currently in
--forgive me for the bloody hell ugly coding.
local function show_current_position()
	local f = require('nvim-treesitter').statusline({
		indicator_size = 500,
		type_patterns = {
			"class",
			"function",
			"method",
			"interface",
			"type_spec",
			"table",
			"if_statement",
			"for_statement",
			"for_in_statement" },
		separator = '->'
	})
	if f == nil then f = "*" end
	return string.gsub(
		string.gsub(
			string.replace(
				string.format("%s", f),
				'function',
				''),
			"(for([^)]+.))",
			"for(󰇘)"),
		"(if([^)]+.))",
		"if(󰇘)")
end



require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {
		lualine_a = { {
			show_current_position,
			color = { fg = 'gray', bg = 'black', gui = 'bold' }
		}
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	inactive_winbar = {},
	extensions = {}

}




-- || Lsp
-- ||
-- ||
--[[Now commented due to coc extensions doing all the lsp work
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end
local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...'location'
    settings = {
      ["rust-analyzer"] = {}
    }
}  ]]
-- || Pretty-Fold Configurations
-- ||
-- ||
require('pretty-fold').setup {
	sections = {
		left = {
			'content',
		},
		right = {
			' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
			function(config) return config.fill_char:rep(3) end
		}
	},
	fill_char = '•',
	remove_fold_markers = true,
	-- Keep the indentation of the content of the fold string.
	keep_indentation = true,
	-- Possible values:
	-- "delete" : Delete all comment signs from the fold string.
	-- "spaces" : Replace all comment signs with equal number of spaces.
	-- false    : Do nothing with comment signs.
	process_comment_signs = 'spaces',
	-- Comment signs additional to the value of `&commentstring` option.
	comment_signs = {},
	-- List of patterns that will be removed from content foldtext section.
	stop_words = {
		'@brief%s*',       -- (for C++) Remove '@brief' and all spaces after.
	},
	add_close_pattern = true, -- true, 'last_line' or false
	matchup_patterns = {
		{ '{',  '}' },
		{ '%(', ')' }, -- % to escape lua pattern char
		{ '%[', ']' }, -- % to escape lua pattern char
	},
	ft_ignore = { 'neorg' },
}

-- || Vimtex Configurations
-- ||
-- ||
vim.g.vimtex_view_method = 'zathura'
vim.g.maplocalleader = ","




vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_open_ip = ''
vim.g.mkdp_browser = '/bin/google-chrome-stable_new'
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_browserfunc = ''
-- The following setting is commented due to format error in lua, idk the correction.
--[[ vim.g.mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ } ]]
vim.g.mkdp_markdown_css = ''
vim.g.mkdp_highlight_css = ''
vim.g.mkdp_port = ''
vim.g.mkdp_page_title = '${name}'
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_theme = 'dark'

-- || vim markdown configuration
-- ||
-- ||
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_folding_disabled = 1

-- || tex-conceal configuration
-- ||
-- ||
-- vim.g.tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
-- vim.g.tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
