local M = {}
local clock = require("nvim-wtii.clock")

M.setup = function()
end

M.current_time = function()
    print(clock.current_time())
end

return M
