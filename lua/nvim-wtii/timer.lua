local M = {}

local timer = nil
local timer_window_id = nil

local get_sec = function(number, char)
	if number == 0 then
		return 0
	end

	if char == "h" then
		return number * 24 * 60
	elseif char == "m" then
		return number * 60
	elseif char == "s" then
		return number
	else
		return 0
	end
end

local to_number = function(char)
	return string.byte(char) - string.byte("0")
end

local convert_to_sec = function(timer_str)
	local sec = 0
	local num = 0
	for i = 1, #timer_str do
		local c = timer_str:sub(i, i)
		if c == "h" or c == "m" or c == "s" then
			sec = sec + get_sec(num, c)
		else
            if (num == 0 and c == '0') then
                goto continue
            end
			num = (num * 10) + to_number(c)
		end
	    ::continue::
	end
	return sec
end

local show_popup = function(str)
	vim.schedule(function()
		local bufnr = vim.api.nvim_create_buf(false, true)
		local lines = { " " .. str .. " " }

		vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
		vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
		vim.api.nvim_buf_set_option(bufnr, "readonly", true)

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

		vim.api.nvim_open_win(bufnr, true, opts)
	end)
end

local show_check_timer_popup = function(str)
	vim.schedule(function()
		local bufnr = vim.api.nvim_create_buf(false, true)
		local lines = { " " .. str .. " " }

		vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)

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

		timer_window_id = vim.api.nvim_open_win(bufnr, true, opts)
	end)
end

local update_popup = function(buf_str)
	if not timer_window_id then
		return
	end
	local lines = { " " .. buf_str .. " sec" }
	vim.schedule(function()
		local bufnr = vim.fn.winbufnr(timer_window_id)
        if bufnr == -1 then
            return
        end
		vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, lines)
	end)
end

local event_timer_update = function()
    local timer_update_loop = vim.uv.new_timer()
    timer_update_loop:start(100, 100, function()
        if timer == nil or timer_window_id == nil then
            return
        end
        if vim.uv.timer_get_due_in(timer) == 0 then
            return
        end
        update_popup(math.floor(vim.uv.timer_get_due_in(timer) / 1000) .. " sec")
    end)
end

M.start_timer = function()
    if timer ~= nil and vim.uv.timer_get_due_in(timer) ~= 0 then
        print("timer is working currently")
        return
    end
	vim.ui.input({ prompt = "timer value: (ex) 1h2m2s" }, function(input)
		local timer_sec = convert_to_sec(input)

		timer = vim.uv.new_timer()
		timer:start(timer_sec * 1000, 0, function()
			show_popup("time's up")
		end)
	end)
end

M.check_timer = function()
    if not timer then
        return
    end
    show_check_timer_popup(vim.uv.timer_get_due_in(timer) / 1000)
end

M.setup = function()
    event_timer_update()
end

return M
