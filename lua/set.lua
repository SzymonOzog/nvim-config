
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.g.python_recommended_style = 0
