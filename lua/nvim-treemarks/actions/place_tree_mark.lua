local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function module.execute(args)
	print("Place mark called")

	local marks_with_cwd = utility.load_marks_cwd()
	local root_mark = nil
	for uuid, mark_el in pairs(marks_with_cwd) do
		if mark_el.is_active_root then
			root_mark = mark_el
		end
	end
	if not root_mark then
		print("No root mark found, not doing anything")
		do
			return
		end
	end
	print(vim.inspect(root_mark.uuid))
	local new_mark = utility.construct_mark()
	print(vim.inspect(new_mark))
	new_mark.parent = root_mark.uuid
	root_mark.children[#root_mark.children + 1] = new_mark.uuid
	local both_marks = {}
	both_marks[root_mark.uuid] = root_mark
	both_marks[new_mark.uuid] = new_mark
	utility.save_marks_by_uuid_to_disk(user_config.marks_file, both_marks)
end

function module.stop() end

function module.complete(arg_lead) end

return module
