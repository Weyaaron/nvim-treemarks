local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function module.execute(args)
	print("Goto Root called")

	local current_file = vim.fn.expand("%")
	local current_dir = vim.fn.getcwd()
	local current_line_pos = vim.api.nvim_win_get_cursor(0)
	local new_root_uuid = utility.uuid()

	--We have to change just this, otherwise changes are not propagated back.
	local marks = utility.load_json_file(user_config.marks_file)
	local marks_with_cwd = utility.load_marks_cwd()
	local mark_that_is_active_root = nil
	for uuid, mark_el in pairs(marks_with_cwd) do
		if mark_el.is_root and mark_el.is_active_root then
			mark_that_is_active_root = mark_el
		end
	end
	if mark_that_is_active_root then
		local new_file_pos = mark_that_is_active_root.file
		local new_cp_pos = mark_that_is_active_root.pos
		vim.cmd("e" .. new_file_pos)
		vim.api.nvim_win_set_cursor(0, new_cp_pos)
	else
		print("No root node")
	end
end

function module.stop() end

function module.complete(arg_lead) end

return module
