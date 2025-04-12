local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.configure(args) end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function module.execute(args)
	print("Place mark called")

	local current_file = vim.fn.expand("%")
	local current_dir = vim.fn.getcwd()
	local current_line_pos = vim.api.nvim_win_get_cursor(0)
	local mark_uuid = utility.uuid()
	local marks = utility.load_json_file(user_config.anchor_file)
	local marks_with_cwd = utility.load_marks_cwd()

	local most_recently_used = nil

	-- local anchor_of_current_working_dir = nil
	-- print(vim.inspect(current_anchors))
	-- for index_el, anchor_el in pairs(current_anchors) do
	-- 	print(anchor_el.file)
	-- 	if anchor_el.file:starts(current_dir) then
	-- 		anchor_of_current_working_dir = anchor_el
	-- 	end
	-- end
	-- if not anchor_of_current_working_dir then
	-- 	print("No Anchor found. Please place anchor first, see config for details")
	-- end
	if anchor_of_current_working_dir then
		--Deletes the old anchor
		current_anchors[anchor_of_current_working_dir.uuid] = nil
		utility.write_json_file(user_config.anchor_file, current_anchors)
	end
end

function module.stop() end

function module.complete(arg_lead) end

return module
