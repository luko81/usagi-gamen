local transition = require("usagigamen.transition")
local timer = require("usagigamen.timer")
local rect_object = require("usagigamen.display.rect")
local circ_object = require("usagigamen.display.circ")
local text_object = require("usagigamen.display.text")
local group_object = require("usagigamen.display.group")
local scene_object = require("usagigamen.display.scene")

-- global for hot reload
if not DisplayState then DisplayState = {} end

local display = {
    CONTENT_WIDTH = usagi.GAME_W,
    CONTENT_HEIGHT = usagi.GAME_H,
    CONTENT_CENTER_X = usagi.GAME_W / 2,
    CONTENT_CENTER_Y = usagi.GAME_H / 2,

    defaults = require("usagigamen.display.defaults"),
}

display.new_scene = function()
    return scene_object.new_scene_object()
end

local scenes = { }
local current_scene_name = "default"
scenes["default"] = display.new_scene()
local default_scene = scenes["default"] -- default_scene rendes on top of everything
local current_scene = scenes[current_scene_name]

display.go_to_scene = function(name)
    if name == current_scene_name then return end
    if not scenes[name] then
        local scene = require(name)
        if scene.create and type(scene.create) == "function" then
            scene:create()
        end
        scenes[name] = scene
    end
    local previous_scene = current_scene
    current_scene = scenes[name]
    current_scene_name = name
    DisplayState.current_scene_name = name -- persist across hot reloads
    if previous_scene and type(previous_scene.hide) == "function" then
        previous_scene:hide()
    end
    if current_scene and type(current_scene.show) == "function" then
        current_scene:show()
    end
end

display.reload = function()
    -- hot reload preserves globals across saved edits but resets locals
    if DisplayState.current_scene_name then
        display.go_to_scene(DisplayState.current_scene_name)
    end
end

display.new_rect = function(x, y, width, height, color, options)
    options = options or {}
    options.parent = options.parent or default_scene
    return rect_object.new_rect_object(x, y, width, height, color, options)
end

display.new_circ = function(x, y, radius, color, options)
    options = options or {}
    options.parent = options.parent or default_scene
    return circ_object.new_circ_object(x, y, radius, color, options)
end

display.new_text = function(x, y, text, color, options)
    options = options or {}
    options.parent = options.parent or default_scene
    return text_object.new_text_object(x, y, text, color, options)
end

display.new_group = function(options)
    options = options or {}
    options.parent = options.parent or default_scene
    return group_object.new_group_object(options)
end

function display:update(dt)
    current_scene:update(dt)
    default_scene:update(dt)
    timer:_update(dt)
    transition:_update(dt)
end

function display:draw(dt)
    gfx.clear(current_scene.color or gfx.COLOR_BLACK)
    current_scene:draw(dt)
    default_scene:draw(dt)
end

return display