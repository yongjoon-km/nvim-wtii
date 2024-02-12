local M = {}

local convert_to_sec = function(timer_str)
    -- 1h2m3s
    -- TODO: Need to create time string parser
    local h, m, s = string.match(timer_str, "(%d+)h(%d+)m(%d+)s")
    local timer_sec = h * 3600 + m * 60 + s
    return timer_sec
end

M.start_timer = function()
	vim.ui.input({ prompt = "timer value: (ex) 1h2m2s" }, function(input)

        local timer_sec = convert_to_sec(input)

		local timer = vim.uv.new_timer()
		timer:start(timer_sec * 1000, 0, function()
            -- TODO: Need to popup alert menu
            print("timer done!!!")
		end)
	end)
end

return M
