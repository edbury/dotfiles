-- Inline images in markdown. Resolves vault attachment paths the way obsidian.nvim does.
return {
  "snacks.nvim",
  opts = {
    image = {
      enabled = true,
      resolve = function(path, src)
        local ok, api = pcall(require, "obsidian.api")
        if ok and api.path_is_note(path) then
          return api.resolve_attachment_path(src)
        end
      end,
    },
  },
}
