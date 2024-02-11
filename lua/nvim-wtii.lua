local M = {}
local clock = require("nvim-wtii.clock")

M.setup = function()
    clock.setup()
end

M.current_time = function()
    clock.display_time_window()
end

return M
