local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function module.execute(mark_uuid)
	if not mark_uuid then
		print("Selection failed")
		do
			return
		end
	end
	print("Choosen uid", mark_uuid)

	local marks_with_cwd = utility.load_marks_cwd()
	-- print(vim.inspect(marks_with_cwd))
	local choosen_mark = marks_with_cwd[mark_uuid]
	if not choosen_mark then
		print("Selection from the node list failed")
		do
			return
		end
	end
	local new_file_pos = choosen_mark.file
	local new_cp_pos = choosen_mark.pos
	vim.cmd("e" .. new_file_pos)
	vim.api.nvim_win_set_cursor(0, new_cp_pos)

	print("Exetuting move to mark")
end

return module
