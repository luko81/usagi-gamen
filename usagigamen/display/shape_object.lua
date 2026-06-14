local display_defaults = require("usagigamen.display.defaults")
local display_object = require("usagigamen.display.display_object")

-- Parameters:
-- options: same as display_object.new_display_object and:
-- color - fill color (default display_defaults.fill_color - gfx.COLOR_WHITE)
-- stroke_color - stroke color (default display_defaults.stroke_color - gfx.COLOR_BLACK)
-- stroke_width - stroke width (default 0 - no stroke)
local function new_shape_object(options)
    options = options or {}
    local shape_object = display_object.new_display_object(options)
    shape_object.color = options.color or display_defaults.fill_color
    shape_object.stroke_color = options.stroke_color or display_defaults.stroke_color
    shape_object.stroke_width = options.stroke_width or 0

    return shape_object
end

return {
    new_shape_object = new_shape_object,
}