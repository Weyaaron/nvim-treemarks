local native_ui = require("nvim-treemarks.selection_methods.native_ui")

local telescope_ui = require("nvim-treemarks.selection_methods.telescope_ui")
local module = {
	NativeUI = native_ui,
	TelescopeUI = telescope_ui,
	-- GotoRootMark = goto_root_mark,
}

return module
