local user_config = require("nvim-treemarks.user_config")
local utility = require("nvim-treemarks.utility")

local module = {}

function module.setup(args) end

function module.choose(initial_list) end
function module.choose_async(initial_list, callback)
	--Todo: Use Telescope
	local uuids = utility.get_keys(initial_list)
	vim.ui.input({ prompt = "Enter a uuid to choose a parent:\n" .. table.concat(uuids, "\n") }, callback)
end

function module.next_cyclic() end

function module.next() end

return module
