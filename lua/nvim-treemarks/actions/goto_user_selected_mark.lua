local utility = require("nvim-treemarks.utility")

local effects = require("nvim-treemarks.effects")
local selection_methods = require("nvim-treemarks.selection_methods")
local module = {}

function module.configure(args) end

function module.execute(args)
	print("Goto User Mark called")

	local marks_with_cwd = utility.load_marks_cwd()
	local telescope_ui = selection_methods.TelescopeUI
	telescope_ui.choose_async(marks_with_cwd, effects.GoToMark.execute)
end

function module.stop() end

function module.complete(arg_lead) end

return module
