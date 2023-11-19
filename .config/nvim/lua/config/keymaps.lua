-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<c-q>", "<c-w>q", { desc = "Close window" })
