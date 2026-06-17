local display_defaults = require("usagigamen.display.defaults")
local group_object = require("usagigamen.display.group_object")

-- Parameters:
-- options: same as display_object.new_display_object and:
-- scene_color - scene background color (default display_defaults.scene_color - gfx.COLOR_BLACK)
local function new_scene_object(options)
    options = options or { }
    if options.parent then options.parent = nil end -- Scene cannot have a parent

    local scene = group_object.new_group_object(options)
    scene.color = options.scene_color or display_defaults.scene_color

    scene.camera = {
        x = 0,
        y = 0,
    }

    function scene:local_to_content(x, y)
        return x - self.camera.x, y - self.camera.y
    end

    function scene:create()
        -- Override this method to add display objects to the scene.
    end

    function scene:show()
        -- Override this method to handle scene showing.
    end

    function scene:hide()
        -- Override this method to handle scene hiding.
    end

    return scene
end

return {
    new_scene_object = new_scene_object,
}
