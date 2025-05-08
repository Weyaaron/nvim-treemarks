local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function module.execute()
	local marks_with_cwd = utility.load_marks_cwd()
	local curr_win = vim.api.nvim_get_current_win()
	local root = utility.choose_root_from_list(marks_with_cwd)

	local curr_buff = vim.api.nvim_win_get_buf(0)
	vim.api.nvim_set_current_win(curr_win)
	utility.open_mark_as_window(root, {})

	local children = utility.resolve_children(root, marks_with_cwd)
	for uuid, child_el in pairs(children) do
		utility.open_mark_as_window(child_el)
	end

	vim.api.nvim_set_current_win(curr_win)
end

return module
