-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (before lazy setup)
vim.g.mapleader = "\\"

-- Load plugins
require("lazy").setup("plugins", {
  performance = {
    rtp = {
      disabled_plugins = {},
    },
  },
})

-- ========================
-- Options (ported from .vimrc)
-- ========================
vim.opt.compatible = false
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.background = "dark"
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.backspace = "indent,eol,start"
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.colorcolumn = "101"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 20
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.autoread = true

-- Auto-refresh buffers when files change on disk
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Poll for file changes every 1s (works even without focus)
vim.fn.timer_start(1000, function()
  if vim.fn.mode() ~= "c" then
    vim.cmd("silent! checktime")
  end
end, { ["repeat"] = -1 })

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")
vim.cmd("colorscheme desert")

-- ========================
-- Keymaps (ported from .vimrc)
-- ========================

-- Toggle cursorline & cursorcolumn
vim.keymap.set("n", "<SPACE>", function()
  vim.wo.cursorcolumn = not vim.wo.cursorcolumn
  vim.wo.cursorline = not vim.wo.cursorline
end)

vim.keymap.set("n", "<F3>", ":set wrap!<CR>")
vim.keymap.set("n", "<F6>", ":bn<CR>")
vim.keymap.set("n", "<F5>", ":bp<CR>")
vim.keymap.set("n", "<F2>", ":e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>")
vim.keymap.set("n", "<TAB><TAB><TAB>", ":set expandtab! expandtab?<CR>")
vim.keymap.set("v", "<space>", "zf")

for i = 1, 9 do
  vim.keymap.set("n", "z" .. i, ":set foldlevel=" .. (i - 1) .. "<CR><Esc>")
end

vim.keymap.set("n", "<F8>", ":set list!<CR>")
vim.keymap.set("i", "<F8>", "<C-o>:set list!<CR>")
vim.keymap.set("c", "<F8>", "<C-c>:set list!<CR>")

vim.keymap.set("n", "<F9>", ":cprevious<CR>")
vim.keymap.set("n", "<F10>", ":cnext<CR>")
vim.keymap.set("n", "<F11>", ":tp<CR>")
vim.keymap.set("n", "<F12>", ":tn<CR>")

vim.keymap.set("n", "<Leader>b", ":ls<CR>:b<Space>")
