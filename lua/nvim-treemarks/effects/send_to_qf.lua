local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function module.execute_many(uuid_list)
	local marks_with_cwd = utility.load_marks_cwd()

	local file_pointers = {}
	for uuid, mark_el in pairs(marks_with_cwd) do
		file_pointers[#file_pointers + 1] = { filename = mark_el.file, lnum = mark_el.pos[1] }
	end
	-- print(vim.inspect(file_pointers))

	vim.fn.setqflist({}, "r")
	vim.fn.setqflist(file_pointers, "a")
end

return module
