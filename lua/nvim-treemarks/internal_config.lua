local internal_config = {
	header_length = 5,
	buffer_length = 20,
	line_length = 70,
	global_hl_namespace = vim.api.nvim_create_namespace("DefaultTreeMarksHlSpace"),
	buf_id = vim.api.nvim_create_buf(false, ""),
}

return internal_config
