local goto_mark = require("nvim-treemarks.effects.goto_mark")
local send_qf = require("nvim-treemarks.effects.send_to_qf")

local module = {
	GoToMark = goto_mark,
	SendQf = send_qf,
}

return module
