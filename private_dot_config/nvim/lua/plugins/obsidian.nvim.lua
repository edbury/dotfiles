-- On the phone, Dropsync keeps the vault in shared storage
local vault = require("config.termux") and "~/storage/shared/vaults/garden" or "~/Dropbox/vaults/garden"

-- Frontmatter keys already in a note, read from its buffer or file.
-- Returns nil for a note that doesn't exist yet, plus the buffer number if loaded.
local function existing_keys(note)
  if not note.path then
    return nil
  end
  local path = tostring(note.path)
  local lines
  local buf = vim.fn.bufnr(path)
  if buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) then
    lines = vim.api.nvim_buf_get_lines(buf, 0, 200, false)
  elseif vim.uv.fs_stat(path) then
    lines = vim.fn.readfile(path, "", 200)
    buf = nil
  else
    return nil
  end
  local keys = {}
  if lines[1] == "---" then
    for i = 2, #lines do
      if lines[i] == "---" then
        break
      end
      local key = lines[i]:match("^([^%s:#][^:]*):")
      if key then
        keys[key] = true
      end
    end
  end
  return keys, buf
end

-- Matches the vault's Linter setup: no id, empty tags/aliases left out,
-- date-created/date-modified/title on new notes, date-modified bumped on edited saves.
local function frontmatter(note)
  local out = require("obsidian.builtin").frontmatter(note)
  local keys, buf = existing_keys(note)
  local now = os.date("%Y-%m-%dT%H:%M")
  if keys == nil then
    out.id = nil
    out["date-created"] = now
    out["date-modified"] = now
    if type(note.title) == "string" and note.title ~= "" then
      out.title = note.title
    end
  else
    if not keys.id then
      out.id = nil
    end
    if keys["date-modified"] and buf and vim.bo[buf].modified then
      out["date-modified"] = now
    end
  end
  if vim.tbl_isempty(out.aliases or {}) and not (keys and keys.aliases) then
    out.aliases = nil
  end
  if vim.tbl_isempty(out.tags or {}) and not (keys and keys.tags) then
    out.tags = nil
  end
  return out
end

-- Filenames are the note title as typed, like the Obsidian app ("Vault Setups.md").
local function note_id(title, dir)
  local base = "Untitled"
  if title and title ~= "" then
    base = (title:gsub('[\\/:*?"<>|#^%[%]]', ""))
  end
  if not dir then
    return base
  end
  local candidate, n = base, 1
  while vim.uv.fs_stat(tostring(dir) .. "/" .. candidate .. ".md") do
    candidate = base .. " " .. n
    n = n + 1
  end
  return candidate
end

-- The date a template is being filled for: a daily note's own date (its id is
-- YYYY-MM-DD), otherwise now. Noon avoids DST edge cases when adding a day.
local function note_time(ctx)
  local id = ctx and ctx.partial_note and ctx.partial_note.id
  local y, m, d = tostring(id or ""):match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  if y then
    return os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 12 })
  end
  return os.time()
end

local obsidian = {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = "garden",
        path = vault,
      },
    },
    -- auto-detection checks telescope, fzf-lua and mini.pick before snacks
    picker = {
      name = "snacks.picker",
    },
    -- obsidian.nvim's UI module is slated for removal; render-markdown.nvim draws notes instead
    ui = {
      enable = false,
    },
    -- the app's "default location for new notes"
    notes_subdir = "_inbox",
    new_notes_location = "notes_subdir",
    note_id_func = note_id,
    note = {
      template = vim.NIL, -- no bundled template; frontmatter() below fills new notes
    },
    templates = {
      folder = "toolshed/templates",
      -- Match the Periodic Notes plugin, so one template works in both apps:
      -- {{date}} is the daily note's own date (obsidian.nvim would use today),
      -- {{yesterday}} and {{tomorrow}} are the neighboring days' note names.
      substitutions = {
        date = function(ctx, suffix)
          return require("obsidian.date").format(note_time(ctx), suffix or Obsidian.opts.templates.date_format)
        end,
        yesterday = function(ctx)
          return os.date("%Y-%m-%d", note_time(ctx) - 86400)
        end,
        tomorrow = function(ctx)
          return os.date("%Y-%m-%d", note_time(ctx) + 86400)
        end,
      },
    },
    attachments = {
      folder = "toolshed/assets/img",
    },
    frontmatter = {
      func = frontmatter,
      sort = { "aliases", "date-created", "date-modified", "dg-publish", "id", "tags", "title" },
    },
    daily_notes = {
      folder = "field-notes",
      date_format = "%Y-%m-%d",
      template = "daily-note.md", -- shared with Periodic Notes in the Obsidian app
      default_tags = {},
      workdays_only = false,
    },
  },
  keys = {
    { "<leader>o", "", desc = "+obsidian", mode = { "n", "x" } },

    -- Top level commands
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch" },
    { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily note" },
    { "<leader>om", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's daily note" },
    { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Daily notes list" },
    { "<leader>oN", "<cmd>Obsidian new_from_template<cr>", desc = "New note from template" },
    { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Switch workspace" },
    { "<leader>og", "<cmd>Obsidian tags<cr>", desc = "Tags" },
    { "<leader>oh", "<cmd>Obsidian help<cr>", desc = "Help" },
    { "<leader>oH", "<cmd>Obsidian helpgrep<cr>", desc = "Help grep" },

    -- Note commands
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in note" },
    { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Follow link" },
    { "<leader>oc", "<cmd>Obsidian toc<cr>", desc = "Table of contents" },
    { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },

    -- rename, template and the visual commands become code actions in 3.17.0,
    -- so these call the LSP and the actions module directly
    {
      "<leader>or",
      function()
        vim.lsp.buf.rename(nil, { name = "obsidian-ls" })
      end,
      desc = "Rename note",
    },
    {
      "<leader>oT",
      function()
        require("obsidian.actions").insert_template()
      end,
      desc = "Insert template",
    },
    {
      "<leader>ox",
      function()
        require("obsidian.actions").toggle_checkbox()
      end,
      desc = "Toggle checkbox",
      mode = { "n", "x" },
    },

    -- Visual mode
    {
      "<leader>oe",
      function()
        require("obsidian.actions").extract_note()
      end,
      desc = "Extract to note",
      mode = "x",
    },
    {
      "<leader>oL",
      function()
        require("obsidian.actions").link()
      end,
      desc = "Link to note",
      mode = "x",
    },
    {
      "<leader>oK",
      function()
        require("obsidian.actions").link_new()
      end,
      desc = "Link to new note",
      mode = "x",
    },
  },
}

-- marksman (from the LazyVim markdown extra) duplicates obsidian-ls completions,
-- definitions and rename inside the vault, and flags links to notes that don't exist yet.
-- It still runs on markdown files outside the vault.
local vault_real = vim.uv.fs_realpath(vim.fn.expand(vault))

local function in_vault(fname)
  local real = vim.uv.fs_realpath(fname) or fname
  return vault_real ~= nil and vim.startswith(real, vault_real .. "/")
end

local marksman = {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {
        -- handles both root_dir(bufnr, on_dir) and the older root_dir(fname)
        root_dir = function(arg, on_dir)
          local fname = type(arg) == "number" and vim.api.nvim_buf_get_name(arg) or arg
          if in_vault(fname) then
            return nil
          end
          local root = vim.fs.root(fname, { ".marksman.toml", ".git" }) or vim.fs.dirname(fname)
          if on_dir then
            on_dir(root)
          else
            return root
          end
        end,
      },
    },
  },
}

-- The Obsidian Linter owns formatting in the vault, so markdownlint (from the
-- LazyVim markdown extra) doesn't check notes there and nothing formats them on save.
-- Both still run on markdown outside the vault.
local markdownlint = {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        condition = function(ctx)
          return not in_vault(ctx.filename)
        end,
      },
    },
  },
}

obsidian.init = function()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("obsidian_vault_autoformat", { clear = true }),
    pattern = "markdown",
    callback = function(args)
      if in_vault(vim.api.nvim_buf_get_name(args.buf)) then
        vim.b[args.buf].autoformat = false
      end
    end,
  })
end

return { obsidian, marksman, markdownlint }
