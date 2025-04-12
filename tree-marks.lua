local utility = require("utility")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function uuid()
	math.randomseed(os.time())
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

function append_json_to_file(path, data)
	local file = io.open(path, "a")

	local data_as_str = vim.json.encode(data)

	file:write(data_as_str .. "\n")
	file:close()
end

local tree_marks_path = "/home/aaron/treemarks.json"

local function load_path(target_path)
	local result = {}
	local file = io.open(target_path, "r")

	local data = file:read("a")

	local lines = utility.split_str(data)
	for ii, line_el in pairs(lines) do
		if #line_el > 1 then
			result[#result + 1] = vim.json.decode(line_el)
		end
	end

	file:close()
	return result
end

local function choose_mark()
	local full_data = load_path(tree_marks_path)

	local data = { "hallo", "2" }

	local table_as_strs = {}
	for i, v in pairs(full_data) do
		table_as_strs[#table_as_strs + 1] = tostring(v.uuid) .. tostring(v.file)
	end
	local colors = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = "colors",
				finder = finders.new_table({
					results = table_as_strs,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						print(vim.inspect(selection))
						vim.api.nvim_put({ selection[1] }, "", false, true)
					end)
					return true
				end,
			})
			:find()
	end

	colors()
end
local function set_mark()
	local current_file = vim.fn.expand("%")
	local current_dir = vim.fn.getcwd()
	local current_line_pos = vim.api.nvim_win_get_cursor(0)
	local full_data = { file = current_dir .. "/" .. current_file, pos = current_line_pos, uuid = uuid() }
	append_json_to_file(tree_marks_path, full_data)
end

vim.keymap.set("n", "m", set_mark, { desc = "Set a mark based on file" })
vim.keymap.set("n", "M", choose_mark, { desc = "Choose a mark based on project" })
