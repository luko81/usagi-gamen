local display = require("usagigamen.display")

local scene = display.new_scene()

function scene:create()
    scene.color = gfx.COLOR_DARK_PURPLE

    local header_text = display.new_text(display.CONTENT_CENTER_X, display.CONTENT_CENTER_Y, "This is the main scene.", gfx.COLOR_WHITE)
    header_text.anchor_y = 1
    header_text.scale = 2
    scene:insert(header_text)
    local text = display.new_text(display.CONTENT_CENTER_X, display.CONTENT_CENTER_Y, "Use BTN1 to switch scenes or BTN2 to exit.", gfx.COLOR_WHITE)
    text.anchor_y = 0
    scene:insert(text)
end

function scene:show()
    print("Main scene is now visible.")
end

function scene:hide()
    print("Main scene is now hidden.")
end

function scene:_update(dt)
    if input.pressed(input.BTN1) then
        display.go_to_scene("examples.scenes.second_scene")
    elseif input.key_pressed(input.KEY_BACKSPACE) or input.pressed(input.BTN2) then
        display.go_to_scene("menu_scene")
    end
end

return scene