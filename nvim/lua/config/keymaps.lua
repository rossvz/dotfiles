-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ut", function()
  if vim.g.colors_name == "rose-pine" then
    vim.cmd("colorscheme tokyonight")
  else
    vim.cmd("colorscheme rose-pine")
  end
end, { desc = "Toggle light/dark theme" })
