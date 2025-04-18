local user_config = {
	dev_mode = false,
	marks_file = vim.fn.stdpath("data") .. "/nvim-treemarks/marks.json", -- The path used to store the marks.
	filter_marks_by_git_branch = true, -- Wether marks should be filtered by git-branch,
	logging_args = {
		enable_logging = true,
		--According to https://neovim.io/doc/user/starting.html#_standard-paths, as of 2025-01, log currently points to state.
		-- Splitting the path from the name has been done to support to support checks for the existence of the directory.
		log_directory_path = vim.fn.stdpath("log") .. "/nvim-treemarks/",
		log_file_path = os.date("%Y-%m-%d") .. ".log",
		display_logs = false,
		display_warnings = true,
	},
}
return user_config
