local place_root_mark = require("nvim-treemarks.actions.place_root_mark")
local goto_root_mark = require("nvim-treemarks.actions.goto_root_mark")
local place_child_mark = require("nvim-treemarks.actions.place_tree_mark")

local goto_user_selected_mark = require("nvim-treemarks.actions.goto_user_selected_mark")
local module = {
	PlaceRootMark = place_root_mark,
	PlaceChildMark = place_child_mark,
	GotoRootMark = goto_root_mark,
	GotoUserSelectedMark = goto_user_selected_mark,
}

return module
