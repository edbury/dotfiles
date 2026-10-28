return {
  "snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        header = [[
                                    ░██            
                                    ░██            
 ░████████ ░██░████ ░█████████████  ░██ ░████████  
░██    ░██ ░███     ░██   ░██   ░██ ░██ ░██    ░██ 
░██    ░██ ░██      ░██   ░██   ░██ ░██ ░██    ░██ 
░██   ░███ ░██      ░██   ░██   ░██ ░██ ░██    ░██ 
 ░█████░██ ░██      ░██   ░██   ░██ ░██ ░██    ░██ 
       ░██                                         
 ░███████                                          
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "find file", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "new file", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "restore session", section = "session" },
          { icon = " ", key = "x", desc = "lazy extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "quit", action = ":qa" },
        },
      },
    },
  },
}
