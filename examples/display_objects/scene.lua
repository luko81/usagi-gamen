local display = require("usagigamen.display")

local scene = display.new_scene()

function scene:create()
    scene.color = gfx.COLOR_DARK_PURPLE

    local PADDING = 8
    local ITEM_SIZE = 32

    local layout_group = display.new_group({
        parent = scene,
        x = PADDING,
        y = PADDING,
    })

    local function get_item_x(col)
        return (col - 1) * (ITEM_SIZE + PADDING) + ITEM_SIZE / 2
    end

    local function get_item_y(row)
        return (row - 1) * (ITEM_SIZE + PADDING) + ITEM_SIZE / 2
    end

    -- fill rectangle
    local rect_fill = display.new_rect(get_item_x(1), get_item_y(1), ITEM_SIZE, ITEM_SIZE, gfx.COLOR_PEACH)
    layout_group:insert(rect_fill)

    -- stroke rectangle
    local rect_stroke = display.new_rect(get_item_x(1), get_item_y(2), ITEM_SIZE, ITEM_SIZE, 0)
    rect_stroke.stroke_color = gfx.COLOR_PEACH
    rect_stroke.stroke_width = 1
    layout_group:insert(rect_stroke)

    -- stroked rectangle - fat stroke
    -- using options instead of setting properties after creation
    local rect_stroke_fat = display.new_rect(get_item_x(1), get_item_y(3), ITEM_SIZE, ITEM_SIZE, 0, {
        parent = layout_group,
        stroke_color = gfx.COLOR_PEACH,
        stroke_width = 4
    })

    -- filled rectangle with stroke
    -- using options only for parent
    local rect_fill_stroke = display.new_rect(get_item_x(1), get_item_y(4), ITEM_SIZE, ITEM_SIZE, gfx.COLOR_INDIGO, { parent = layout_group })
    rect_fill_stroke.stroke_color = gfx.COLOR_PEACH
    rect_fill_stroke.stroke_width = 1

    -- filled circle
    local circ_fill = display.new_circ(get_item_x(2), get_item_y(1), ITEM_SIZE / 2, gfx.COLOR_PEACH)
    layout_group:insert(circ_fill)

    -- stroked circle
    local circ_stroke = display.new_circ(get_item_x(2), get_item_y(2), ITEM_SIZE / 2, 0)
    circ_stroke.stroke_color = gfx.COLOR_PEACH
    circ_stroke.stroke_width = 1
    layout_group:insert(circ_stroke)

    -- stroked circle - fat stroke
    local circ_stroke_fat = display.new_circ(get_item_x(2), get_item_y(3), ITEM_SIZE / 2, 0)
    circ_stroke_fat.stroke_color = gfx.COLOR_PEACH
    circ_stroke_fat.stroke_width = 4
    layout_group:insert(circ_stroke_fat)

    -- filled circle with stroke
    local circ_fill_stroke = display.new_circ(get_item_x(2), get_item_y(4), ITEM_SIZE / 2, gfx.COLOR_INDIGO)
    circ_fill_stroke.stroke_color = gfx.COLOR_PEACH
    circ_fill_stroke.stroke_width = 1
    layout_group:insert(circ_fill_stroke)

    -- text
    local text = display.new_text(get_item_x(4), get_item_y(1), "Hello, Usagi!", gfx.COLOR_WHITE)
    layout_group:insert(text)

    -- text scaled up
    local text_scaled = display.new_text(get_item_x(4), get_item_y(2), "Hello!", gfx.COLOR_WHITE)
    text_scaled.scale = 2
    layout_group:insert(text_scaled)

    -- text with alpha
    local text_alpha = display.new_text(get_item_x(4), get_item_y(3), "Hello, Alpha!", gfx.COLOR_WHITE)
    text_alpha.alpha = 0.5
    layout_group:insert(text_alpha)
    
    -- text rotated
    local text_rotated = display.new_text(get_item_x(4), get_item_y(4), "Hello, Rotated!", gfx.COLOR_WHITE)
    text_rotated.rotation = 10
    layout_group:insert(text_rotated)

    -- group with rectangles (with anchors) and text
    local group_1 = display.new_group()
    group_1.x = get_item_x(6)
    group_1.y = get_item_y(2) - 16
    layout_group:insert(group_1)
    local rect_1 = display.new_rect(0, 0, ITEM_SIZE, ITEM_SIZE, gfx.COLOR_BLACK)
    group_1:insert(rect_1)
    local rect_2 = display.new_rect(0, 0, ITEM_SIZE, ITEM_SIZE, gfx.COLOR_INDIGO)
    rect_2.anchor_x = 1
    rect_2.anchor_y = 1
    group_1:insert(rect_2)
    local rect_3 = display.new_rect(0, 0, ITEM_SIZE, ITEM_SIZE, gfx.COLOR_RED)
    rect_3.anchor_x = 0
    rect_3.anchor_y = 0
    group_1:insert(rect_3)
    local text_1 = display.new_text(0, -4, "Group", gfx.COLOR_WHITE)
    text_1.anchor_y = 1
    group_1:insert(text_1)
    local text_2 = display.new_text(0, 0, "and", gfx.COLOR_WHITE)
    group_1:insert(text_2)
    local text_3 = display.new_text(0, 4, "Anchors", gfx.COLOR_WHITE)
    text_3.anchor_y = 0
    group_1:insert(text_3)

    -- group with rectangles (reordered) and text
    local group_2 = display.new_group()
    group_2.x = get_item_x(6)
    group_2.y = get_item_y(4) - 16
    layout_group:insert(group_2)
    local rect_4 = display.new_rect(0, 0, ITEM_SIZE + 16, ITEM_SIZE + 8, gfx.COLOR_BLACK)
    group_2:insert(rect_4)
    local rect_5 = display.new_rect(0, 0, ITEM_SIZE, ITEM_SIZE, gfx.COLOR_INDIGO)
    rect_5.anchor_x = 1
    rect_5.anchor_y = 1
    group_2:insert(rect_5)
    local rect_6 = display.new_rect(0, 0, ITEM_SIZE, ITEM_SIZE, gfx.COLOR_RED)
    rect_6.anchor_x = 0
    rect_6.anchor_y = 0
    group_2:insert(rect_6)
    rect_4:to_front()
    local text_4 = display.new_text(0, -4, "Object", gfx.COLOR_WHITE)
    text_4.anchor_y = 1
    group_2:insert(text_4)
    local text_5 = display.new_text(0, 0, "to", gfx.COLOR_WHITE)
    group_2:insert(text_5)
    local text_6 = display.new_text(0, 4, "Front", gfx.COLOR_WHITE)
    text_6.anchor_y = 0
    group_2:insert(text_6)

    -- last column
    local last_column_x = get_item_x(8) - PADDING
    -- local debug_rect = display.new_rect(last_column_x, get_item_y(1), ITEM_SIZE, ITEM_SIZE, gfx.COLOR_PEACH)
    -- layout_group:insert(debug_rect)

    -- sprite with animation
    local sprite_1 = display.new_animated_sprite(last_column_x, get_item_y(1))
    sprite_1.frame_index = 11
    layout_group:insert(sprite_1)
    -- sequence by frames
    -- sprite_1:add_sequence("idle", { frames = { 11, 12, 13, 14 }, fps = 6 })
    -- sequence by start and count
    sprite_1:add_sequence("idle", { start = 11, count = 4, fps = 6 })
    sprite_1:add_sequence("run", { start = 21, count = 16, fps = 12 })
    sprite_1:play("idle")

    -- sprite with flipped x
    local sprite_2 = display.new_sprite(last_column_x, get_item_y(2), 11)
    sprite_2.flip_x = true
    layout_group:insert(sprite_2)

    -- sprite with alpha
    local sprite_3 = display.new_sprite(last_column_x, get_item_y(3), 11)
    sprite_3.alpha = 0.5
    layout_group:insert(sprite_3)

    -- sprite with rotation
    local sprite_4 = display.new_sprite(last_column_x, get_item_y(4), 11)
    sprite_4.rotation = -90
    layout_group:insert(sprite_4)
end

function scene:_update(dt)
    if input.key_pressed(input.KEY_BACKSPACE) or input.pressed(input.BTN2) then
        display.go_to_scene("menu_scene")
    end
end

return scene