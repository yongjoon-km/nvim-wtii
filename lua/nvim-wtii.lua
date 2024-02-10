local M = {}
local clock = require("nvim-wtii.clock")

-- The window id of displaying current time. This will be used for closing the window.
-- Only one window is available now.
local time_win_id = nil

local update_time = function(time)
    if not time_win_id then
        return
    end
	local lines = { " " .. time }
    vim.schedule(function()
        local bufnr = vim.fn.winbufnr(time_win_id)
        vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
    end)

end

M.setup = function()
    vim.on_key(function()
        if not time_win_id then
            return
        end
        vim.api.nvim_win_close(time_win_id, true)
        time_win_id = nil
    end)

    -- timer to update time value if window is active
    local timer = vim.uv.new_timer()
    timer:start(100, 100, function()
        update_time(clock.current_time())
    end)

end


M.current_time = function()
	local bufnr = vim.api.nvim_create_buf(false, true)
	local lines = { " " .. clock.current_time() }

	vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)

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
