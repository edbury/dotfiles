local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- set leader key to <space>
vim.g.mapleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ignore case on search...
vim.opt.ignorecase = true

-- highlight on search
vim.opt.hlsearch = true

-- quickly turn off highlighting with <leader>n
vim.api.nvim_set_keymap('n', '<leader>n', ":nohlsearch<cr>", { noremap = true, silent = true })

-- trim trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- quickly close buffer with <leader>d
vim.api.nvim_set_keymap('n', '<leader>d', ':bp|bd #<CR>', { noremap = true })

-- ensure we get a title
vim.opt.title = true

-- show line numbers
vim.opt.number = true

-- show matching bracket, etc
vim.opt.showmatch = true

-- allow buffers in the background
vim.opt.hidden = true

-- show incomplete commands in status bar
vim.opt.showcmd = true

-- don't bother me, vim
vim.opt.belloff = all

-- start scrolling when we're 8 lines from the margin
vim.opt.scrolloff = 8

-- use system clipboard by default
vim.opt.clipboard = unnamed

-- indentation and whitespace
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
-- vim.opt.noshiftround = true
vim.opt.linebreak = true

-- stifle interruptive prompts
vim.opt.shortmess = atI

-------------------
-- PLUGIN CONFIG --
-------------------
require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "bash",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "regex",
        "scss",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {"nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>\\", "<cmd>NvimTreeToggle<cr>", desc = "Toggle tree" },
    },
    config = function()
      require("nvim-tree").setup {
        sync_root_with_cwd = true,
      }
    end,
  },
  {"numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {}
    end,
  },
  {"nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>l", "<cmd>Telescope buffers<cr>", desc = "Search buffers" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep files" },
    }
  },
  {"ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      require("leap").setup({})
      require("leap").add_default_mappings()
    end,
  },
  {"kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  {"chriskempson/base16-vim"},
})


vim.opt.background = dark

vim.opt.termguicolors = true

-- automatch our terminal theme in vim
if vim.fn.filereadable(vim.fn.expand("~/.vimrc_background"))
  then
    vim.g.base16colorspace = 256
    vim.cmd('source ~/.vimrc_background')
end
