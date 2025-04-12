if vim.g.loaded_treemarks == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_treemarks = 1

local function my_cmd(opts)
	local subcommand_tbl = require("nvim-treemarks.actions")
	local subcommand_key = opts.fargs[1]
	local sub_args = vim.list_slice(opts.fargs, 2, #opts.fargs)
	local subcommand = subcommand_tbl[subcommand_key]
	if not subcommand then
		print(
			"TreeMarks subcommand: " .. subcommand_key .. " is not supported! Please check for spelling/open a issue."
		)
		return
	end
	if subcommand then
		subcommand.execute(sub_args)
	end
end

vim.api.nvim_create_user_command("TreeMarks", my_cmd, {
	nargs = "+",
	desc = "Move effieciently with marks organized as a tree",
	complete = function(arg_lead, cmdline, _)
		local subcommand_tbl = require("nvim-treemarks.actions")
		-- Get the subcommand.
		local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*TreeMarks[!]*%s(%S+)%s(.*)$")
		if subcmd_key and subcmd_arg_lead and subcommand_tbl[subcmd_key] and subcommand_tbl[subcmd_key].complete then
			-- The subcommand has completions. Return them.
			return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
		end
		-- Check if cmdline is a subcommand
		if cmdline:match("^['<,'>]*TreeMarks[!]*%s+%w*$") then
			-- Filter subcommands that match
			local subcommand_keys = vim.tbl_keys(subcommand_tbl)
			return vim.iter(subcommand_keys)
				:filter(function(key)
					return key:find(arg_lead) ~= nil
				end)
				:totable()
		end
	end,
})
