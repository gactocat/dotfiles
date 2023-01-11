local git_status, git = pcall(require, 'git')
if not git_status then return end

git.setup {}
