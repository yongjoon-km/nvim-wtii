local M = {}
local clock = require("nvim-wtii.clock")
local timer = require("nvim-wtii.timer")

M.setup = function()
    clock.setup()
end

M.current_time = function()
    clock.display_time_window()
end

M.start_timer = function()
    timer.start_timer()
end

M.check_timer = function()
    timer.check_timer()
end

return M
