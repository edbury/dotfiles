-- True when Neovim is running inside Termux on Android.
-- Every Termux package lives under the app's prefix, /data/data/com.termux/files/usr.
return (vim.env.PREFIX or ""):find("com.termux", 1, true) ~= nil
