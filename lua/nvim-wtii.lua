local M = {}
local clock = require("nvim-wtii.clock")

M.setup = function() end

M.current_time = function()
	local bufnr = vim.api.nvim_create_buf(false, true)
	local lines = { clock.current_time() }

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = 20,
		height = 5,
		row = 5,
		col = 100,
		border = "rounded",
	}

	local win_id = vim.api.nvim_open_win(bufnr, true, opts)
end

return M
