local has_git_worktree, git_worktree = pcall(require, "git-worktree")
if not has_git_worktree then
	return
end

git_worktree.setup({
	-- change_directory_command = "tcd",
})
