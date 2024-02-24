local window = require("nvim-wtii.window")

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
	time_window_id = window.show_popup(now_time_str(), { readonly = false })
end

return M
