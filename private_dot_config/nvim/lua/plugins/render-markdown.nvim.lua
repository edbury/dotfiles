-- render-markdown.nvim comes from the LazyVim markdown extra.
-- Every markdown character stays visible: no icons or symbols drawn over markup,
-- nothing concealed, and the same view in every mode and on the cursor line.
-- Heading text color and code block shading are the only things it adds.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    render_modes = true, -- render in insert mode too, so headings and code blocks don't change while typing
    anti_conceal = { enabled = false },
    win_options = {
      conceallevel = { default = 0, rendered = 0 }, -- show [[ ]], *, ` and other markup
    },
    heading = {
      icons = {}, -- keep the # characters
      backgrounds = {}, -- no colored bar behind headings
      sign = false,
    },
    code = {
      border = "thick", -- keep the ``` fence lines visible, shaded like the block
      conceal_delimiters = false,
      language_icon = false,
      sign = false,
    },
    bullet = { enabled = false },
    quote = { enabled = false }, -- also turns off callout rendering
    checkbox = { enabled = false },
    link = { enabled = false },
    dash = { enabled = false },
    pipe_table = { enabled = false },
    yaml = { enabled = false },
    html = { enabled = false },
  },
}
