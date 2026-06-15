local display_defaults = require("usagigamen.display.defaults")
local dispplay_object = require("usagigamen.display.display_object")

-- Parameters:
-- x, y - position
-- text - text string
-- color - text color
-- options - table with additional options: scale, alpha, rotation, and for display_object
local function new_text_object(x, y, text, color, options)
    options = options or {}
    options.x = x or 0
    options.y = y or 0
    options.color = color or display_defaults.text_color

    local text_object = dispplay_object.new_display_object(options)

    function text_object:_update_text_size()
        if self.text and self.text ~= "" and self.scale then
            self.width, self.height = usagi.measure_text(self.text)
            self.width = self.width * self.scale
            self.height = self.height * self.scale
        else
            self.width, self.height = 0, 0
        end
    end

    function text_object:_property_changed(key, value)
        if key == "text" or key == "scale" then
            self:_update_text_size()
        end
    end

    text_object.text = text or ""
    text_object.scale = options.scale or 1
    text_object.color = color or display_defaults.text_color
    text_object.alpha = options.alpha or 1
    text_object.rotation = options.rotation or 0

    function text_object:_draw_text(dt)
        local x, y = self:local_to_content(self.x - self.width * self.anchor_x, self.y - self.height * self.anchor_y)
        if self.text and self.text ~= "" and self.color > 0 then
            if self.scale ~= 1 or self.alpha ~= 1 or self.rotation ~= 0 then
                local rotation_rad = self.rotation * math.pi / 180
                gfx.text_ex(self.text, x, y, self.scale, rotation_rad, self.color, self.alpha)
            else
                gfx.text(self.text, x, y, self.color)
            end
        end
    end

    function text_object:_draw_display_object(dt)
        self:_draw_text(dt)
    end

    return text_object
end

return {
    new_text_object = new_text_object
}