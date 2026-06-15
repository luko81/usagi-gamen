local display_object = require("usagigamen.display.display_object")

-- Parameters:
-- x, y - position (default 0)
-- frame_index - sprite index (default 1)
-- options - table with additional options for display_object
local function new_sprite_object(x, y, frame_index, options)
    options = options or {}
    options.x = x or 0
    options.y = y or 0
    options.width = options.width or usagi.SPRITE_SIZE
    options.height = options.height or usagi.SPRITE_SIZE

    local sprite = display_object.new_display_object(options)
    sprite.frame_index = frame_index or 1
    sprite.flip_x = options.flip_x or false
    sprite.flip_y = options.flip_y or false
    sprite.rotation = options.rotation or 0
    sprite.tint = options.tint or gfx.COLOR_TRUE_WHITE
    sprite.alpha = options.alpha or 1

    function sprite:_draw_sprite(dt)
        if self.frame_index > 0 then
            local x, y = self:local_to_content(self.x - self.width * self.anchor_x, self.y - self.height * self.anchor_y)
            local rotation_rad = self.rotation * math.pi / 180
            gfx.spr_ex(self.frame_index, x, y, self.flip_x, self.flip_y, rotation_rad, self.tint, self.alpha)
        end
    end

    function sprite:_draw_display_object(dt)
        self:_draw_sprite(dt)
    end

    return sprite
end

return {
    new_sprite_object = new_sprite_object,
}