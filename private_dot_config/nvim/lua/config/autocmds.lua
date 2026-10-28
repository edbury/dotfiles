-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Indent guides off by default in markdown. At column 0 they only show on the
-- blank line after the cursor's block. <leader>ug toggles them for the buffer.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_indent_guides", { clear = true }),
  pattern = "markdown",
  callback = function(args)
    vim.b[args.buf].snacks_indent = false
    Snacks.toggle({
      name = "Indent Guides (buffer)",
      get = function()
        return vim.b[args.buf].snacks_indent ~= false
      end,
      set = function(state)
        vim.b[args.buf].snacks_indent = state
        vim.cmd.redraw({ bang = true })
      end,
    }):map("<leader>ug", { buffer = args.buf })
  end,
})
