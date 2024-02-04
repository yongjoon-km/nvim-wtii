local M = {}

M.current_time = function()
    local time = os.date("*t")
    return ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec)
end

return M
