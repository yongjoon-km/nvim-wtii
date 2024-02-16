local M = {}
local clock = require("nvim-wtii.clock")
local timer = require("nvim-wtii.timer")

M.setup = function()
    clock.setup()
    timer.setup()
end

M.current_time = function()
    clock.display_time_window()
end

M.start_timer = function()
    timer.start_timer()
end

M.open_timer_checker = function()
    timer.open_timer_checker()
end

return M
