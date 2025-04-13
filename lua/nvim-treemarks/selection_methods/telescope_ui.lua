local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local module = {}

function module.setup(args) end

function module.choose(initial_list) end
function module.choose_async(initial_list, callback)
	local table_as_strs = {}
	for i, v in pairs(initial_list) do
		table_as_strs[#table_as_strs + 1] = v.uuid
	end
	print(vim.inspect(table_as_strs))
	pickers
		.new({}, {
			prompt_title = "TreeMarks",
			finder = finders.new_table({
				results = table_as_strs,
				-- function(entry)
				-- 	-- print(vim.inspect(entry))
				-- 	return { value = entry.uuid, display = entry.uuid }
				-- end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
					-- As long as we match the original uuid we are fine with this
					callback(selection[1])
				end)
				return true
			end,
		})
		:find()
end

function module.next_cyclic() end

function module.next() end

return module
