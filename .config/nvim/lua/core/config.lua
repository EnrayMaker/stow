-- vim.g.did_load_filetypes = 1
vim.g.formatoptions = "qrn1"
-- vim.opt.showmode = false
vim.opt.updatetime = 100
vim.wo.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.wo.linebreak = true
vim.opt.virtualedit = "block"
vim.opt.undofile = true
vim.opt.shell = "/bin/fish"

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Shorter messages
vim.opt.shortmess:append("c")

-- Indent Settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- Fillchars
vim.opt.fillchars = {
	vert = "│",
	fold = "⠀",
	eob = " ", -- suppress ~ at EndOfBuffer
	-- diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}

-- ОТОБРАЖЕНИЕ
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.isfname:append("@-@")
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.pumheight = 10
vim.opt.autoread = true
vim.opt.timeoutlen = 500

-- ПОИСК
vim.opt.hlsearch = true -- Подсвечивать все совпадения поиска.
vim.opt.incsearch = true -- Подсвечивать совпадения по мере ввода.
vim.opt.ignorecase = true -- Игнорировать регистр при поиске.
vim.opt.smartcase = true -- Если в поиске есть заглавные буквы, поиск становится чувствительным к регистру. (Лучшая комбинация с ignorecase)

-- vim.cmd([[highlight clear LineNr]])
-- vim.cmd([[highlight clear SignColumn]])
-- vim.opt.cursorline = true
-- vim.opt.colorcolumn = "80"

-- Добавьте настройки для Python
vim.g.python3_host_prog = vim.fn.exepath("python3")

-- Автокоманды для работы с Python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.commentstring = "# %s"
	end,
})
