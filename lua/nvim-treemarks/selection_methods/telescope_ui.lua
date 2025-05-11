local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.setup(args) end

function module.choose(initial_list) end
function module.choose_async(initial_table, callback)
	local indexed_table = utility.construct_i_indexed_table(initial_table)
	local finder = finders.new_table({
		results = indexed_table,
		entry_maker = function(entry)
			local displayed_name = entry.uuid
			-- print(vim.inspect(entry))

			if entry.name then
				if #entry.name > 0 then
					displayed_name = entry.name
				end
			end

			return {
				value = entry,
				display = displayed_name,
				ordinal = displayed_name,
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
					-- print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
					-- As long as we match the original uuid we are fine with this
					if selection then
						callback(selection["value"].uuid)
					end
				end)
				return true
			end,
		})
		:find()
end

function module.next_cyclic() end

function module.next() end

return module
