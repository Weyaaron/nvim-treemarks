local place_root_mark = require("nvim-treemarks.actions.place_root_mark")
local goto_root_mark = require("nvim-treemarks.actions.goto_root")
local place_child_mark = require("nvim-treemarks.actions.place_tree_mark")
local module = {
	PlaceRootMark = place_root_mark,
	PlaceChildMark = place_child_mark,
	GotoRootMark = goto_root_mark,
}

return module
