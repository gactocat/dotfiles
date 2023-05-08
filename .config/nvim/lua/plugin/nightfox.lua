local status, _ = pcall(vim.cmd, 'colorscheme nightfox')
if not status then return end
