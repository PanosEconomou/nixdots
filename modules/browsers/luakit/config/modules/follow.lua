-- Describe how to follow hints behavior
local select = require "select"

-- Set alphanumeric hints
select.label_maker = function(s)
    local chars = s.charset("fjdkghsla")
    return s.trim(s.sort(s.reverse(chars)))
end
