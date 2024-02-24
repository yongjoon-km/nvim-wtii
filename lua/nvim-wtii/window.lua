local M = {}

M.show_popup = function(str, opt)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local lines = { " " .. str .. " " }

	vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
	if opt.readonly then
		vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
		vim.api.nvim_buf_set_option(bufnr, "readonly", true)
	end

	local width = string.len(str) + 2
	local height = 3
	local row = (vim.fn.winheight(0) / 2) - (height / 2)
	local col = (vim.fn.winwidth(0) / 2) - (width / 2)

	local opts = {
		style = "minimal",
		relative = "win",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
	}

	return vim.api.nvim_open_win(bufnr, true, opts)
end

return M
