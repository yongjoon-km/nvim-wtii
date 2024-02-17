local M = {}

M.to_number = function(char)
	return string.byte(char) - string.byte("0")
end

M.time_to_sec = function(amount, unit)
	if amount == 0 then
		return 0
	end

	if unit == "h" then
		return amount * 24 * 60
	elseif unit == "m" then
		return amount * 60
	elseif unit == "s" then
		return amount
	else
		return 0
	end
end

return M
