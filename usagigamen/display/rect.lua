local display_defaults = require("usagigamen.display.defaults")
local shape_object = require("usagigamen.display.shape_object")

-- Parameters:
-- x, y - position
-- width, height - dimensions
-- color - fill color
-- options - table with additional options for shape_object and display_object
local function new_rect_object(x, y, width, height, color, options)
    options = options or {}
    options.x = x or 0
    options.y = y or 0
    options.width = width or 0
    options.height = height or 0
    options.color = color or display_defaults.fill_color

    local rect = shape_object.new_shape_object(options)

    function rect:_draw()
        local x, y = self:local_to_content(self.x - self.width * self.anchor_x, self.y - self.height * self.anchor_y)
        if self.color > 0 then
            gfx.rect_fill(x, y, self.width, self.height, self.color)
        end
        if self.stroke_width > 0 and self.stroke_color > 0 then
            gfx.rect_ex(x, y, self.width, self.height, self.stroke_width, self.stroke_color)
        end
    end

    return rect
end

return {
    new_rect_object = new_rect_object,
}