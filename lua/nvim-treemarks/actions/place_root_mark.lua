local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function module.execute(args)
	print("Place Root called")

	--We have to change just this, otherwise changes are not propagated back.
	local marks = utility.load_json_file(user_config.marks_file)
	local marks_with_cwd = utility.load_marks_cwd()
	local mark_that_is_active_root = utility.choose_root_from_list(marks_with_cwd)

	local new_root_mark = utility.construct_mark()
	new_root_mark.is_root = true
	new_root_mark.is_active_root = true
	if mark_that_is_active_root then
		marks[mark_that_is_active_root.uuid].is_active_root = false
	end
	marks[new_root_mark.uuid] = new_root_mark

	utility.save_marks_by_uuid_to_disk(user_config.marks_file, marks)
end

function module.stop() end

function module.complete(arg_lead) end

return module
