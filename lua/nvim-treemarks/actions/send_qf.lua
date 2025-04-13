local utility = require("nvim-treemarks.utility")
local effects = require("nvim-treemarks.effects")
local module = {}

function module.configure(args) end

function module.execute(args)
	local marks_with_cwd = utility.load_marks_cwd()
	effects.SendQf.execute_many(marks_with_cwd)
end

function module.stop() end

function module.complete(arg_lead) end

return module
