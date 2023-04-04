local git_status, git = pcall(require, 'git')
if not git_status then return end

git.setup {
  keymaps = {
    blame = '<Leader>vb',
    quit_blame = 'q',
    blame_commit = '<cr>',
    browse = '<Leader>vo',
    open_pull_request = '<Leader>vp',
    create_pull_request = '<Leader>vn',
    diff = '<Leader>vd',
    diff_close = '<Leader>vD',
    revert = '<Leader>vr',
    revert_file = '<Leader>vR',
  },
  target_branch = 'master',
}
