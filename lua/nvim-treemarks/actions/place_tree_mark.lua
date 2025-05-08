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
	local both_marks = {}

	--Todo: Rework
	local function on_action(input)
		if not input then
			print("No choice, will do nothing")
			do
				return
			end
		end
		local choosen_mark = nil
		for uuid, mark_el in pairs(marks_with_cwd) do
			if uuid == input then
				choosen_mark = mark_el
			end
		end
		if not choosen_mark then
			print("No parent mark choosen, will not create new mark")
			do
				return
			end
		end

		local new_mark = utility.construct_mark()
		new_mark.parent = choosen_mark.uuid
		marks_with_cwd[choosen_mark.uuid].children[#marks_with_cwd[choosen_mark.uuid].children + 1] = new_mark.uuid
		both_marks[choosen_mark.uuid] = choosen_mark
		both_marks[new_mark.uuid] = new_mark
		utility.save_marks_by_uuid_to_disk(user_config.marks_file, both_marks)
	end

	local telescope_ui = require("nvim-treemarks.selection_methods").TelescopeUI
	telescope_ui.choose_async(marks_with_cwd, on_action)
end

function module.stop() end

function module.complete(arg_lead) end

return module
