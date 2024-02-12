local M = {}

local convert_to_sec = function(timer_str)
	-- 1h2m3s
	-- TODO: Need to create time string parser
	local h, m, s = string.match(timer_str, "(%d+)h(%d+)m(%d+)s")
	local timer_sec = h * 3600 + m * 60 + s
	return timer_sec
end

function show_popup(str)
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

M.start_timer = function()
	vim.ui.input({ prompt = "timer value: (ex) 1h2m2s" }, function(input)
		local timer_sec = convert_to_sec(input)

		local timer = vim.uv.new_timer()
		timer:start(timer_sec * 1000, 0, function()
			show_popup("time's up")
		end)
	end)
end

return M
