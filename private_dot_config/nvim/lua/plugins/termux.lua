-- Termux runs Android (Bionic) binaries, so Mason's prebuilt glibc downloads fail there.
-- Tools come from `pkg install` instead and LazyVim enables servers found on $PATH.
if not require("config.termux") then
  return {}
end

return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
}
