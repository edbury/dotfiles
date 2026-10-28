return {
  {
    "tinted-theming/tinted-nvim",
    priority = 1000, -- load colorscheme early
    lazy = false, -- apply on startup
    opts = {
      default_scheme = "base24-0x96f", -- used until tinty has set a scheme
      apply_scheme_on_startup = true,
      compile = true,
      -- follow the scheme tinty last applied, and switch live when it changes
      selector = {
        enabled = true,
        mode = "file",
        path = "~/.local/share/tinted-theming/tinty/current_scheme",
        watch = true,
      },
    },
  },

  -- LazyVim otherwise loads tokyonight at startup before tinted-nvim
  { "LazyVim/LazyVim", opts = { colorscheme = "base24-0x96f" } },
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
}
