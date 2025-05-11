local utility = require("nvim-treemarks.utility")
local effects = require("nvim-treemarks.effects")
local module = {}

function module.configure(args) end

function module.init() end

function module.next()
	print("Cycling to next node depth first called, currently random")

	local marks_with_cwd = utility.load_marks_cwd()
	local marks_as_int_table = utility.construct_i_indexed_table(marks_with_cwd)
	local random_node = math.random(1, #marks_as_int_table)
	return marks_as_int_table[random_node].uuid
end
function module.stop() end

function module.complete(arg_lead) end

return module
