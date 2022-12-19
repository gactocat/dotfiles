local treesitter_status, treesitter = pcall(require, 'nvim-treesitter.configs')
if not treesitter_status then return end

treesitter.setup {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
        'json',
        'yaml',
        'toml',
        'markdown',
        'dockerfile',
        'gitignore',

        'lua',
        'html',
        'css',
        'javascript',
        'typescript',
        'tsx',
        'go',
        'rust',
    },
}
