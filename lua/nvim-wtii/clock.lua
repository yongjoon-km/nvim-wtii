local M = {}

local time_window_id = nil

local now_time_str = function()
	local time = os.date("*t")
	return ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec)
end

local update_time = function()
	if not time_window_id then
		return
	end
	local lines = { " " .. now_time_str() }
	vim.schedule(function()
		local bufnr = vim.fn.winbufnr(time_window_id)
		vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
	end)
end

local event_remove_window = function()
    vim.on_key(function()
        if not time_window_id then
            return
        end
        vim.api.nvim_win_close(time_window_id, true)
        time_window_id = nil
    end)
end

local event_update_time = function()
    local timer = vim.uv.new_timer()
    timer:start(100, 100, function()
        update_time()
    end)
end

M.setup = function()
    event_remove_window()
    event_update_time()
end

M.display_time_window = function()
	local bufnr = vim.api.nvim_create_buf(false, true)
	local lines = { " " .. now_time_str() }

	vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)

    local width = 10
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

    time_window_id = vim.api.nvim_open_win(bufnr, true, opts)
end

return M
