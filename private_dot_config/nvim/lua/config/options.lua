-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- $grmln: right now, we're only overriding defaults set in `lazyvim.config.options`

local opt = vim.opt

opt.relativenumber = false -- Relative line numbers
opt.scrolloff = 15 -- Lines of context
opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
