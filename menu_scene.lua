local display = require("usagigamen.display")
local transition = require("usagigamen.transition")

local scene = display.new_scene()

function scene:create()
    scene.color = gfx.COLOR_DARK_PURPLE

    local text = display.new_text(display.CONTENT_CENTER_X, display.CONTENT_CENTER_Y, "Hello, Usagi Gamen!")
    text.color = gfx.COLOR_WHITE
    text.scale = 2
    text.y = 20 + text.height / 2
    scene:insert(text)

    local rect = display.new_rect(text.x, text.y, text.width + 16, text.height + 8)
    rect.color = 0
    rect.stroke_color = gfx.COLOR_WHITE
    rect.stroke_width = 1
    scene:insert(rect)
    rect:to_back()

    local menu_items = {
        { text = "Display Objects", scene = "examples.display_objects.scene" },
        { text = "Switching Scenes", scene = "examples.scenes.main_scene" },
        { text = "Transitions and Timers", scene = "examples.transitions.scene" },
        { text = "Camera and Sprites", scene = "examples.camera.scene" },
        { text = "Pixel Paint", scene = "examples.paint.scene" },
    }

    local menu_group = display.new_group()
    scene:insert(menu_group)
    menu_group.x = display.CONTENT_CENTER_X
    menu_group.y = text.y + text.height / 2 + 20

    local ROW_HEIGHT = 16
    local SELECTION_HEIGHT = 16
    local TEXT_COLOR = gfx.COLOR_WHITE
    local TEXT_COLOR_SELECTED = gfx.COLOR_BLACK
    local SELECTION_COLOR = gfx.COLOR_WHITE
    
    local buttons = { }
    for i, item in ipairs(menu_items) do
        local button = display.new_text(0, (i - 1) * ROW_HEIGHT + ROW_HEIGHT / 2, item.text)
        button.color = TEXT_COLOR
        menu_group:insert(button)
        buttons[i] = button
    end

    local selected_index = 1

    local selection = display.new_rect(0, 0, 100, SELECTION_HEIGHT)
    selection.color = SELECTION_COLOR
    menu_group:insert(selection)
    selection:to_back()

    local trans = nil

    local function select_item(index, anim)
        if index < 1 or index > #buttons then
            return
        end
        buttons[selected_index].color = TEXT_COLOR
        selected_index = index
        local button = buttons[selected_index]
        button.color = TEXT_COLOR_SELECTED
        local y = button.y
        local width = button.width + 8
        if not anim then
            selection.y = y
            selection.width = width
        else
            if trans then
                transition.cancel(trans)
                trans = nil
            end
            trans = transition.to(selection, { y = y, width = width, time = 100 })
        end
    end

    select_item(selected_index, false)

    function scene:_update(dt)
        if input.pressed(input.DOWN) then
            select_item(selected_index + 1, true)
        elseif input.pressed(input.UP) then
            select_item(selected_index - 1, true)
        elseif input.pressed(input.BTN1) then
            display.go_to_scene(menu_items[selected_index].scene)
        end
    end
end

return scene