local git_status, git = pcall(require, 'git')
if not git_status then return end

git.setup {
  keymaps = {
    blame = '<Leader>gb',
    quit_blame = 'q',
    blame_commit = '<CR>',
    browse = '<Leader>go',
    open_pull_request = '<Leader>gp',
    create_pull_request = '<Leader>gn',
    diff = '<Leader>gd',
    diff_close = '<Leader>gD',
    revert = '<Leader>gr',
    revert_file = '<Leader>gR',
  },
  target_branch = 'master',
}
