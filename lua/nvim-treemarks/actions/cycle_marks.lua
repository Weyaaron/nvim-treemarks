local utility = require("nvim-treemarks.utility")
local effects = require("nvim-treemarks.effects")
local depth_first = require("nvim-treemarks.iterators.depth_first")
local module = {}

function module.configure(args) end

function module.execute(args)
	print("Cycling through marks.")

	local marks_with_cwd = utility.load_marks_cwd()
	local next_mark = depth_first.next()
	effects.GoToMark.execute(next_mark)
end

function module.stop() end

function module.complete(arg_lead) end

return module
