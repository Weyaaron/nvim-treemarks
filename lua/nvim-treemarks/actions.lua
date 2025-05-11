local place_root_mark = require("nvim-treemarks.actions.place_root_mark")
local goto_root_mark = require("nvim-treemarks.actions.goto_root_mark")
local place_child_mark = require("nvim-treemarks.actions.place_child_mark")
local send_qf = require("nvim-treemarks.actions.send_qf")
local goto_user_selected_mark = require("nvim-treemarks.actions.goto_user_selected_mark")
local open_all_in_windows = require("nvim-treemarks.actions.open_all_in_windows")
local cycle_marks = require("nvim-treemarks.actions.cycle_marks")
-- # Todo: Add Iteration, Both BreathFirst and DeapthFirst
-- Add the ability to open them all in windows
-- Todo: Implement actual config:
-- Window-Opening-Options
-- Implement a public node table
-- Todo: Implement git branch filtering
-- Todo: Improve selection/telescope UI strings
-- Add telescope to the docs

local module = {
	PlaceRootMark = place_root_mark,
	OpenAllInWindow = open_all_in_windows,
	PlaceChildMark = place_child_mark,
	GotoRootMark = goto_root_mark,
	GotoUserSelectedMark = goto_user_selected_mark,
	SendQf = send_qf,
	CycleMarks = cycle_marks,
}

return module
