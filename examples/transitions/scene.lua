local display = require("usagigamen.display")
local transition = require("usagigamen.transition")
local timer = require("usagigamen.timer")

local scene = display.new_scene()

local timer_text_1 = nil
local timer_text_2 = nil
local rect = nil

function scene:create()
    scene.color = gfx.COLOR_DARK_PURPLE

    timer_text_1 = display.new_text(display.CONTENT_CENTER_X, 32, "Time elapsed: 0", gfx.COLOR_WHITE)
    scene:insert(timer_text_1)

    timer_text_2 = display.new_text(48, display.CONTENT_HEIGHT - 32, "Time elapsed: 0", gfx.COLOR_WHITE)
    scene:insert(timer_text_2)

    rect = display.new_rect(display.CONTENT_WIDTH - 48, display.CONTENT_CENTER_Y - 24, 32, 32, gfx.COLOR_PEACH)
    scene:insert(rect)
end

local trans1 = nil
local trans2 = nil
local trans3 = nil
local tmr = nil
local count = 0
local value = 0

local function scale_up()
    local function scale_down()
        trans1 = transition.to(timer_text_1, { time = 3000, scale = 1, on_complete = scale_up })
    end
    trans1 = transition.to(timer_text_1, { time = 3000, scale = 2, on_complete = scale_down })
end

local function move_right()
    local function move_left()
        trans2 = transition.to(timer_text_2, { time = 2000, x = 48, on_complete = move_right })
    end
    trans2 = transition.to(timer_text_2, { time = 2000, x = display.CONTENT_WIDTH - 48, on_complete = move_left })
end

local function move_left()
    local function move_right()
        trans3 = transition.to(rect, { time = 2000, x = display.CONTENT_WIDTH - 48, y = display.CONTENT_CENTER_Y - 24, width = 32, height = 32, on_complete = move_left })
    end
    trans3 = transition.to(rect, { time = 2000, x = 48, y = display.CONTENT_CENTER_Y + 24, width = 48, height = 48, on_complete = move_right })
end

local function spawn_bullet()
    local bullet = display.new_circ(-10, display.CONTENT_HEIGHT - 10, 4, gfx.COLOR_INDIGO)
    scene:insert(bullet)
    transition.to(bullet, { x = display.CONTENT_WIDTH + 10, time = 1000, tag = "bullet", on_complete = function() bullet:destroy() end })
end

local function update_timer(event)
    count = count + 1
    if count > 9 then
        count = 0
        value = value + 1
        timer_text_1.text = "Time elapsed: " .. value
        timer_text_2.text = "Time elapsed: " .. value
    end
    spawn_bullet()
end

function scene:show()
    tmr = timer.perform_with_delay(100, update_timer, 0)
    timer_text_1.scale = 1
    scale_up()
    timer_text_2.x = 48
    move_right()
    rect.x = display.CONTENT_WIDTH - 48
    rect.y = display.CONTENT_CENTER_Y - 24
    rect.width = 32
    rect.height = 32
    move_left()
    transition.resume("bullet")
end

function scene:hide()
    if trans1 then
        transition.cancel(trans1)
        trans1 = nil
    end
    if trans2 then
        transition.cancel(trans2)
        trans2 = nil
    end
    if tmr then
        timer.cancel(tmr)
        tmr = nil
    end
    if trans3 then
        transition.cancel(trans3)
        trans3 = nil
    end
    transition.pause("bullet")
end

function scene:_update(dt)
    if input.key_pressed(input.KEY_BACKSPACE) or input.pressed(input.BTN2) then
        display.go_to_scene("menu_scene")
    end
end

return scene
