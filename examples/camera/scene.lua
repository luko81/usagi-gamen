local display = require("usagigamen.display")

local scene = display.new_scene()
local sprite = nil
local tile_map = nil

local MOVE_SPEED = 128 -- pixels per second
local MIN_VIEW_DISTANCE = 64
local TILE_WIDTH = 16
local TILE_HEIGHT = 16

local tilemap_data = {
    { 2, 3, 4, 5, 3, 4, 4, 5, 3, 4, 4, 4, 5, 3, 5, 3, 4, 4, 4, 5, 3, 4, 4, 5, 3, 4, 5, 2 },
}

local function create_tile(col, row, tile_index)
    local x = (col - 1) * TILE_WIDTH + TILE_WIDTH / 2
    local y = (row - 1) * TILE_HEIGHT + TILE_HEIGHT / 2
    local tile = display.new_sprite(x, y, tile_index)
    return tile
end

local function create_tile_map(data)
    local tile_group = display.new_group()
    for row_index, row in ipairs(data) do
        for col_index, tile_index in ipairs(row) do
            local tile = create_tile(col_index, row_index, tile_index)
            tile_group:insert(tile)
        end
    end
    -- fix for no width and height properties on groups (on todo list)
    tile_group.width = #data[1] * TILE_WIDTH
    tile_group.height = #data * TILE_HEIGHT

    return tile_group
end

function scene:create()
    scene.color = gfx.COLOR_DARK_PURPLE

    tile_map = create_tile_map(tilemap_data)
    scene:insert(tile_map)
    tile_map.x = -48
    tile_map.y = display.CONTENT_CENTER_Y + 4

    sprite = display.new_animated_sprite(display.CONTENT_CENTER_X, display.CONTENT_CENTER_Y)
    scene:insert(sprite)
    sprite:add_sequence("idle", { start = 11, count = 4, fps = 6 })
    sprite:add_sequence("run", { start = 21, count = 16, fps = 16 })
end

function scene:show()
    sprite:play("idle")
end

function scene:hide()
    
end

function scene:_update(dt)
    if input.key_pressed(input.KEY_BACKSPACE) or input.pressed(input.BTN2) then
        display.go_to_scene("menu_scene")
    end
    if input.held(input.RIGHT) then
        if sprite.x >= tile_map.x + tile_map.width then return end  
        if sprite.x >= display.CONTENT_WIDTH + scene.camera.x - MIN_VIEW_DISTANCE then
            scene.camera.x = scene.camera.x + MOVE_SPEED * dt
        end
        sprite.x = sprite.x + MOVE_SPEED * dt
        sprite:play("run")
        sprite.flip_x = false
    elseif input.held(input.LEFT) then
        if sprite.x <= tile_map.x then return end
        if sprite.x <= scene.camera.x + MIN_VIEW_DISTANCE then
            scene.camera.x = scene.camera.x - MOVE_SPEED * dt
        end
        sprite.x = sprite.x - MOVE_SPEED * dt
        sprite:play("run")
        sprite.flip_x = true
    else
        sprite:play("idle")
    end
end

return scene
