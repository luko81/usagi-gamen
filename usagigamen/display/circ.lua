local display_defaults = require("usagigamen.display.defaults")
local shape_object = require("usagigamen.display.shape_object")

-- Parameters:
-- x, y - position (default 0)
-- radius - circle radius (default 0)
-- color - fill color
-- options - table with additional options for shape_object and display_object
local function new_circ_object(x, y, radius, color, options)
    options = options or {}
    options.x = x or 0
    options.y = y or 0
    options.color = color or display_defaults.fill_color

    local circ = shape_object.new_shape_object(options)

    function circ:_property_changed(key, value)
        if key == "radius" then
            self.width = value * 2
            self.height = value * 2
        end
    end
    
    circ.radius = radius or 0

    function circ:_draw_circle(dt)
        -- gfx.circ is draw with 0.5 anchor by default, so adjust for anchor and radius
        local x, y = self:local_to_content(self.x + self.radius - self.width * self.anchor_x, self.y + self.radius - self.height * self.anchor_y)
        if self.color > 0 then
            gfx.circ_fill(x, y, self.radius, self.color)
        end
        if self.stroke_width > 0 and self.stroke_color > 0 then
            gfx.circ_ex(x, y, self.radius, self.stroke_width, self.stroke_color)
        end
    end

    function circ:_draw_display_object(dt)
        self:_draw_circle(dt)
    end

    return circ
end

return {
    new_circ_object = new_circ_object,
}