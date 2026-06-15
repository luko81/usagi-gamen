local display = require("usagigamen.display")
local transition = require("usagigamen.transition")
local timer = require("usagigamen.timer")

local scene = display.new_scene()

local text_1 = nil
local text_2 = nil
local rect = nil
local sprite = nil

function scene:create()
    scene.color = gfx.COLOR_DARK_PURPLE

    text_1 = display.new_text(display.CONTENT_CENTER_X, 32, "Time elapsed: 0", gfx.COLOR_WHITE)
    scene:insert(text_1)

    text_2 = display.new_text(48, display.CONTENT_HEIGHT - 32, "Time elapsed: 0", gfx.COLOR_WHITE)
    scene:insert(text_2)

    rect = display.new_rect(display.CONTENT_WIDTH - 48, display.CONTENT_CENTER_Y - 24, 32, 32, gfx.COLOR_PEACH)
    scene:insert(rect)

    sprite = display.new_animated_sprite(16, display.CONTENT_HEIGHT - 10)
    scene:insert(sprite)
    sprite:add_sequence("run", { start = 21, count = 16, fps = 12 })
    sprite:add_sequence("roll", { start = 41, count = 8, fps = 12 })
end

local trans_scale = nil
local trans_text_2 = nil
local trans_rect = nil
local trans_sprite = nil
local tmr = nil
local count = 0
local value = 0

local function scale_up()
    local function scale_down()
        trans_scale = transition.to(text_1, { time = 3000, scale = 1, on_complete = scale_up })
    end
    trans_scale = transition.to(text_1, { time = 3000, scale = 2, on_complete = scale_down })
end

local function move_right()
    local function move_left()
        trans_text_2 = transition.to(text_2, { time = 2000, x = 48, on_complete = move_right })
    end
    trans_text_2 = transition.to(text_2, { time = 2000, x = display.CONTENT_WIDTH - 48, on_complete = move_left })
end

local function move_left()
    local function move_right()
        trans_rect = transition.to(rect, { time = 2000, x = display.CONTENT_WIDTH - 48, y = display.CONTENT_CENTER_Y - 24, width = 32, height = 32, on_complete = move_left })
    end
    trans_rect = transition.to(rect, { time = 2000, x = 48, y = display.CONTENT_CENTER_Y + 24, width = 48, height = 48, on_complete = move_right })
end

local function spawn_bullet()
    local bullet = display.new_circ(-10, 10, 4, gfx.COLOR_INDIGO)
    scene:insert(bullet)
    transition.to(bullet, { x = display.CONTENT_WIDTH + 10, time = 2000, tag = "bullet", on_complete = function() bullet:destroy() end })
end

local function move_sprite_right()
    local function move_sprite_left()
        sprite.flip_x = true
        sprite:play("run")
        trans_sprite = transition.to(sprite, { time = 2000, x = 16, on_complete = move_sprite_right })
    end
    sprite.flip_x = false
    sprite:play("run")
    trans_sprite = transition.to(sprite, { time = 2000, x = display.CONTENT_WIDTH - 16, on_complete = move_sprite_left })
end

local function update_timer(event)
    count = count + 1
    if count % 2 == 0 then
        spawn_bullet()
    end
    if count > 9 then
        count = 0
        value = value + 1
        text_1.text = "Time elapsed: " .. value
        text_2.text = "Time elapsed: " .. value
    end
end

function scene:show()
    tmr = timer.perform_with_delay(100, update_timer, 0)
    text_1.scale = 1
    scale_up()
    text_2.x = 48
    move_right()
    rect.x = display.CONTENT_WIDTH - 48
    rect.y = display.CONTENT_CENTER_Y - 24
    rect.width = 32
    rect.height = 32
    move_left()
    sprite.x = 16
    move_sprite_right()
    transition.resume("bullet")
end

function scene:hide()
    if tmr then
        timer.cancel(tmr)
        tmr = nil
    end
    if trans_scale then
        transition.cancel(trans_scale)
        trans_scale = nil
    end
    if trans_text_2 then
        transition.cancel(trans_text_2)
        trans_text_2 = nil
    end
    if trans_rect then
        transition.cancel(trans_rect)
        trans_rect = nil
    end
    if trans_sprite then
        transition.cancel(trans_sprite)
        trans_sprite = nil
    end
    transition.pause("bullet")
end

function scene:_update(dt)
    if input.key_pressed(input.KEY_BACKSPACE) or input.pressed(input.BTN2) then
        display.go_to_scene("menu_scene")
    end
end

return scene
