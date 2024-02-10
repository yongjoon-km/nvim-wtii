local M = {}
local clock = require("nvim-wtii.clock")

-- The window id of displaying current time. This will be used for closing the window.
-- Only one window is available now.
local time_win_id = nil

M.setup = function() 
    vim.on_key(function() 
        if not time_win_id then
            return
        end
        vim.api.nvim_win_close(time_win_id, true)
        time_win_id = nil
    end)
end

M.current_time = function()
	local bufnr = vim.api.nvim_create_buf(false, true)
	local lines = { " " .. clock.current_time() }

	vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
    vim.api.nvim_buf_set_option(bufnr, "readonly", true)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

    local width = 10
    local height = 3
    local row = (vim.fn.winheight(0) / 2) - (width / 2)
    local col = (vim.fn.winwidth(0) / 2) - (height / 2)

	local opts = {
		style = "minimal",
		relative = "win",
		width = width,
		height = height,
        row = row,
        col = col,
		border = "rounded",
	}

	local win_id = vim.api.nvim_open_win(bufnr, true, opts)
    time_win_id = win_id
end

return M
