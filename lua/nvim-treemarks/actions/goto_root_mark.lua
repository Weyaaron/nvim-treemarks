local utility = require("nvim-treemarks.utility")
local effects = require("nvim-treemarks.effects")
local module = {}

function module.configure(args) end

function module.execute(args)
	print("Goto Root called")

	local marks_with_cwd = utility.load_marks_cwd()
	local mark_that_is_active_root = utility.choose_root_from_list(marks_with_cwd)
	effects.GoToMark.execute(mark_that_is_active_root)
end

function module.stop() end

function module.complete(arg_lead) end

return module
