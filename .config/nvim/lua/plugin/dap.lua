local dap_status, dap = pcall(require, 'dap')
if not dap_status then return end

local dapui_status, dapui = pcall(require, 'dapui')
if not dapui_status then return end

local mason_nvim_dap_status, mason_nvim_dap = pcall(require, 'mason-vim-dap')
if not mason_nvim_dap_status then return end

dap.setup {}
dapui.setup {}

mason_nvim_dap.setup {
    automatic_setup = true,
}
mason_nvim_dap.setup_handlers {}
