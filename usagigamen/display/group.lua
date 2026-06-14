local group_object = require("usagigamen.display.group_object")

-- Parameters:
-- options: same as display_object.new_display_object
local function new_group_object(options)
    local group = group_object.new_group_object(options)

    return group
end

return {
    new_group_object = new_group_object,
}