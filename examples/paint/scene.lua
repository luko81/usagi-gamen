local display = require("usagigamen.display")

local scene = display.new_scene()

local PIXEL_SIZE = 8
local PIXEL_MARGIN = 1
local PIXEL_COLOR = gfx.COLOR_DARK_GRAY
local PIXEL_SELECTION_COLOR = gfx.COLOR_RED
local PIXEL_SELECTION_WIDTH = 1
local GRID_WIDTH = 16
local GRID_HEIGHT = 16

function scene:create()
    scene.color = gfx.COLOR_BLACK

    local pixels_group = display.new_group()
    scene:insert(pixels_group)

    local pixels = { }
    
    for y = 1, GRID_HEIGHT do
        pixels[y] = { }
        for x = 1, GRID_WIDTH do
            local pixel = display.new_rect((x - 1) * (PIXEL_SIZE + PIXEL_MARGIN) + (PIXEL_SIZE + PIXEL_MARGIN) / 2, (y - 1) * (PIXEL_SIZE + PIXEL_MARGIN) + (PIXEL_SIZE + PIXEL_MARGIN) / 2, PIXEL_SIZE, PIXEL_SIZE)
            pixel.color = PIXEL_COLOR
            pixel.is_selected = false
            pixel.stroke_color = PIXEL_SELECTION_COLOR

            function pixel:select()
                self.is_selected = true
                self.stroke_width = PIXEL_SELECTION_WIDTH
            end

            function pixel:deselect()
                is_selected = false
                self.stroke_width = 0
            end

            function pixel:change_color(color)
                self.color = color
            end

            pixels_group:insert(pixel)
            pixels[y][x] = pixel
        end
    end

    pixels_group.y = (display.CONTENT_HEIGHT - (GRID_HEIGHT * (PIXEL_SIZE + PIXEL_MARGIN) - PIXEL_MARGIN)) / 2
    pixels_group.x = pixels_group.y

    local selected_x, selected_y = 1, 1

    local function get_selected_pixel()
        return pixels[selected_y][selected_x]
    end

    local function select_pixel(x, y)
        local previous_pixel = get_selected_pixel()
        previous_pixel:deselect()
        selected_x, selected_y = x, y
        local pixel = get_selected_pixel()
        pixel:select()
    end

    select_pixel(1, 1)

    function scene:_update(dt)
        if input.pressed(input.RIGHT) then
            select_pixel(math.min(selected_x + 1, GRID_WIDTH), selected_y)
        elseif input.pressed(input.LEFT) then
            select_pixel(math.max(selected_x - 1, 1), selected_y)
        elseif input.pressed(input.DOWN) then
            select_pixel(selected_x, math.min(selected_y + 1, GRID_HEIGHT))
        elseif input.pressed(input.UP) then
            select_pixel(selected_x, math.max(selected_y - 1, 1))
        elseif input.pressed(input.BTN1) then
            local pixel = get_selected_pixel()
            local color = pixel.color
            color = color + 1
            if color > 16 then color = 1 end
            pixel:change_color(color)
        elseif input.key_pressed(input.KEY_BACKSPACE) or input.pressed(input.BTN2) then
            display.go_to_scene("menu_scene")
        end
    end
end

function scene:_update(dt)
    
end

return scene