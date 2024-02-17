local window = require("nvim-wtii.window")
local util = require("nvim-wtii.util")

local M = {}

local timer_obj = {
	window_id = nil,
	timer = nil,
}

local parse_to_sec = function(timer_str)
	local sec = 0
	local num = 0
	for i = 1, #timer_str do
		local c = timer_str:sub(i, i)
		if c == "h" or c == "m" or c == "s" then
			sec = sec + util.time_to_sec(num, c)
		else
			if num == 0 and c == "0" then
				goto continue
			end
			num = (num * 10) + util.to_number(c)
		end
		::continue::
	end
	return sec
end

local update_popup = function(buf_str)
	if not timer_obj.window_id then
		return
	end
	local lines = { " " .. buf_str .. " sec" }
	vim.schedule(function()
		local bufnr = vim.fn.winbufnr(timer_obj.window_id)
		if bufnr == -1 then
			return
		end
		vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
		vim.api.nvim_buf_set_option(bufnr, "readonly", false)
		vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
		vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
		vim.api.nvim_buf_set_option(bufnr, "readonly", true)
	end)
end

local event_timer_update = function()
	local timer_update_loop = vim.uv.new_timer()
	timer_update_loop:start(100, 100, function()
		if timer_obj.timer == nil or timer_obj.window_id == nil then
			return
		end
		if vim.uv.timer_get_due_in(timer_obj.timer) == 0 then
			return
		end
		update_popup(math.floor(vim.uv.timer_get_due_in(timer_obj.timer) / 1000) .. " sec")
	end)
end

M.start_timer = function()
	if timer_obj.timer ~= nil and vim.uv.timer_get_due_in(timer_obj.timer) ~= 0 then
		print("timer is working currently")
		return
	end
	vim.ui.input({ prompt = "timer value: (ex) 1h2m2s" }, function(input)
		local timer_sec = parse_to_sec(input)

		timer_obj.timer = vim.uv.new_timer()
		timer_obj.timer:start(timer_sec * 1000, 0, function()
			window.show_popup("time's up", { readonly = true }, function() end)
		end)
	end)
end

M.open_timer_checker = function()
	if not timer_obj.timer then
		return
	end
	window.show_popup(vim.uv.timer_get_due_in(timer_obj.timer) / 1000, { readonly = true }, function(window_id)
		timer_obj.window_id = window_id
	end)
end

M.setup = function()
	event_timer_update()
end

return M
