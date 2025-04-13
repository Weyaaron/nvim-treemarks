local internal_config = require("nvim-treemarks.internal_config")
local user_config = require("nvim-treemarks.user_config")

local utility = {}

function utility.construct_prompt_from_mark(mark_as_table)
	return mark_as_table.uuid
end

function utility.construct_mark()
	local current_file = vim.fn.expand("%")
	local current_dir = vim.fn.getcwd()
	local current_line_pos = vim.api.nvim_win_get_cursor(0)
	local mark_uuid = utility.uuid()

	local result = {
		file = current_dir .. "/" .. current_file,
		pos = current_line_pos,
		uuid = mark_uuid,
		is_root = false,
		is_active_root = false,
		parent = nil,
		children = {},
	}
	return result
end

function utility.load_marks_cwd()
	--Todo: Add Support for multiple Trees per working dir
	local marks_with_cwd = {}
	local all_tree_data = utility.load_json_file(user_config.marks_file)

	local current_dir = vim.fn.getcwd()
	for uuid_el, mark_el in pairs(all_tree_data) do
		-- print(vim.inspect(mark_el))
		if mark_el.file:starts(current_dir) then
			marks_with_cwd[mark_el.uuid] = mark_el
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

function utility.load_line_template(template_content)
	local lines = {}

	local template_as_line = string.gsub(template_content, "\n", " ")
	for i = 1, #template_as_line, internal_config.line_length do
		local current_text = string.sub(template_as_line, i, i + internal_config.line_length)
		lines[#lines + 1] = current_text
	end
	return table.concat(lines, "\n")
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
