local has_git_conflict, git_conflict = pcall(require, "git-conflict")
if not has_git_conflict then
	return
end

git_conflict.setup({
	disable_diagnostics = true,
	default_mappings = {
		ours = "<leader>ch",
		theirs = "<leader>cl",
		both = "<leader>cb",
	},
})
