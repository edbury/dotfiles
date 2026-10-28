-- Inline images in markdown. Resolves vault attachment paths the way obsidian.nvim does.
-- Off in Termux, which has no terminal graphics protocol to draw them with.
return {
  "snacks.nvim",
  opts = {
    image = {
      enabled = not require("config.termux"),
      resolve = function(path, src)
        local ok, api = pcall(require, "obsidian.api")
        if ok and api.path_is_note(path) then
          return api.resolve_attachment_path(src)
        end
      end,
    },
  },
}
