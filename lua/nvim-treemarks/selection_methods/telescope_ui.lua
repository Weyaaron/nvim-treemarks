local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local module = {}

function module.setup(args) end

function module.choose(initial_list) end
function module.choose_async(initial_list, callback)
	local indexed_table = {}
	for i, v in pairs(initial_list) do
		indexed_table[#indexed_table + 1] = v
	end

	local finder = finders.new_table({
		results = indexed_table,
		entry_maker = function(entry)
			return {
				value = entry,
				display = entry.uuid,
				ordinal = entry.uuid,
				path = entry.file,
				lnum = entry.pos[1],
			}
		end,
	})
	pickers
		.new({}, {
			prompt_title = "TreeMarks",
			finder = finder,
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
					-- As long as we match the original uuid we are fine with this
					callback(selection["value"].uuid)
				end)
				return true
			end,
		})
		:find()
end

function module.next_cyclic() end

function module.next() end

return module
