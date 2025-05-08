local internal_config = require("nvim-treemarks.internal_config")
local user_config = require("nvim-treemarks.user_config")

local utility = {}

function utility.construct_prompt_from_mark(mark_as_table)
	return mark_as_table.uuid
end

function utility.string_starts_with(input_str, str_prefix)
	return string.sub(input_str, 1, string.len(str_prefix)) == str_prefix
end

function utility.resolve_children(starting_mark, marks_table)
	local result = {}

	for i, uuid_el in pairs(starting_mark.children) do
		result[uuid_el] = marks_table[uuid_el]
	end
	return result
end

function utility.open_mark_as_window(mark, args)
	local curr_buff = vim.api.nvim_win_get_buf(0)
	local new_window = vim.api.nvim_open_win(curr_buff, false, { split = "right", win = 0 })

	vim.api.nvim_set_current_win(new_window)
	utility.move_to_mark(mark)
end

function utility.move_to_mark(target_mark)
	if not target_mark then
		return
	end
	local new_file_pos = target_mark.file
	local new_cp_pos = target_mark.pos
	vim.cmd("e" .. new_file_pos)
	vim.api.nvim_win_set_cursor(0, new_cp_pos)
end

function utility.choose_root_from_list(initial_list)
	local mark_that_is_active_root = nil
	for uuid, mark_el in pairs(initial_list) do
		if mark_el.is_root and mark_el.is_active_root then
			mark_that_is_active_root = mark_el
		end
	end
	return mark_that_is_active_root
end
function utility.construct_mark()
	--Todo: Rework to work with invalid values
	local current_file = vim.fn.expand("%")
	local current_dir = vim.fn.getcwd()
	local current_line_pos = vim.api.nvim_win_get_cursor(0)
	local mark_uuid = utility.uuid()
	local current_branch = utility.determine_current_branch()

	local result = {
		file = current_file,
		pos = current_line_pos,
		uuid = mark_uuid,
		is_root = false,
		is_active_root = false,
		parent = nil,
		children = {},
		git_branch = current_branch,
	}
	print("res", vim.inspect(result))
	return result
end

function utility.determine_current_branch()
	local job_res = vim.system({ "git", "branch", "--show-current" }, { text = true }):wait()
	return utility.split_str(job_res.stdout, "\n")[1]
end

function utility.filter_table(input_table, filter_args)
	-- "key", "value", cmp_func
	local result = {}
	for i, filtered_el in pairs(input_table) do
		local should_be_kept = true
		for ii, filter_triple_el in pairs(filter_args) do
			should_be_kept = filter_triple_el[3](filtered_el[filter_triple_el[1]], filter_triple_el[2])
		end
		if should_be_kept then
			result[i] = filtered_el
		end
	end
	return result
end

function utility.load_marks_cwd()
	--Todo: Add Support for multiple Trees per working dir
	local marks_with_cwd = {}
	local all_tree_data = utility.load_json_file(user_config.marks_file)
	local current_branch = utility.determine_current_branch()
	--Todo: Rework into generic filter function with (name, value) pairs as args
	--Todo: Integrate the written filter func
	local current_dir = vim.fn.getcwd()
	for uuid_el, mark_el in pairs(all_tree_data) do
		if utility.string_starts_with(mark_el.file, current_dir) then
			-- marks_with_cwd[mark_el.uuid] = mark_el
			local mark_is_on_current_branch = (mark_el.git_branch == current_branch)
			if not user_config.filter_marks_by_git_branch then
				marks_with_cwd[mark_el.uuid] = mark_el
			end
			if user_config.filter_marks_by_git_branch and mark_is_on_current_branch then
				marks_with_cwd[mark_el.uuid] = mark_el
			end
		end
	end
	return marks_with_cwd
end

function utility.replace_content_in_md(original_content, new_content, boundary_counter)
	local start_index, start_end_index = string.find(original_content, "<!-- s" .. boundary_counter .. " -->", 1, true)
	local end_index, end_end_index = string.find(original_content, "<!-- e" .. boundary_counter .. " -->", 1, true)
	local prefix = original_content:sub(1, start_end_index)
	local suffix = original_content:sub(end_index, #original_content)

	return prefix .. new_content .. "\n" .. suffix
end

function utility.check_for_file_existence(file)
	if not file then
		return false
	end
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok
end

function utility.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end
function utility.get_keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		keys[#keys + 1] = key
	end
	return keys
end

function utility.truth_table(t)
	local keys = {}
	for key, value in pairs(t) do
		keys[value] = true
	end
	return keys
end
function utility.get_line(index)
	return vim.api.nvim_buf_get_lines(internal_config.buf_id, index - 1, index, true)[1]
end

function utility.split_str(input, sep)
	if not input then
		return {}
	end
	if not sep then
		sep = "\n"
	end

	assert(type(input) == "string" and type(sep) == "string", "The arguments must be <string>")
	if sep == "" then
		return { input }
	end

	local res, from = {}, 1
	repeat
		local pos = input:find(sep, from)
		res[#res + 1] = input:sub(from, pos and pos - 1)
		from = pos and pos + #sep
	until not from
	if #res == 0 then
		return { input }
	end
	return res
end
function utility.flatten(input_table, resulting_table)
	if type(input_table) ~= "table" then
		return input_table
	end

	if resulting_table == nil then
		resulting_table = {}
	end

	for i, outer_table_el in pairs(input_table) do
		if type(outer_table_el) == "table" then
			local recursive_result = utility.flatten(outer_table_el, {})
			for ii, inner_table_el in pairs(recursive_result) do
				resulting_table[#resulting_table + 1] = inner_table_el
			end
		else
			resulting_table[#resulting_table + 1] = outer_table_el
		end
	end
	return resulting_table
end

function utility.uuid()
	math.randomseed(os.time())
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

function utility.scandir(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls "' .. directory .. '"')
	for filename in pfile:lines() do
		i = i + 1
		t[i] = filename
	end
	pfile:close()
	return t
end

function utility.load_json_file(target_file_path)
	--Todo: Deal with nonexisting dir
	local file = io.open(target_file_path, "r")
	if file == nil then
		return {}
	end

	local file_content = file:read("a")
	if file_content == "" then
		return {}
	end
	local data = vim.json.decode(file_content)
	file:close()
	return data
end

function utility.save_marks_by_uuid_to_disk(target_file_path, uuid_dict)
	local current_uuid_dict = utility.load_json_file(target_file_path)
	for uuid, mark_el in pairs(uuid_dict) do
		current_uuid_dict[uuid] = mark_el
	end
	os.remove(target_file_path)
	local file = io.open(target_file_path, "w")
	local data_as_str = vim.json.encode(current_uuid_dict)
	file:write(data_as_str)
	file:close()
end

function utility.update_debug_state(new_values)
	if not _G._status then
		_G._status = {}
	end
	for key, value in pairs(new_values) do
		_G._status[key] = value
	end
end

function utility.remove_duplicates_from_iindex_based_table(input_table)
	local output_table = {}
	local hash_table = {}
	for i, v in pairs(input_table) do
		if not hash_table[v] then
			output_table[#output_table + 1] = v
			hash_table[v] = true
		end
	end
	return output_table
end

function utility.construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."
	return base_path
end
return utility
