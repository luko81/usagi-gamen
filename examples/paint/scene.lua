local display = require("usagigamen.display")

local scene = display.new_scene()

local PIXEL_SIZE = 8
local PIXEL_MARGIN = 1
local PIXEL_COLOR = gfx.COLOR_DARK_GRAY
local PIXEL_SELECTION_COLOR = gfx.COLOR_WHITE
local PIXEL_SELECTION_WIDTH = 1
local GRID_WIDTH = 26
local GRID_HEIGHT = 16
local COLOR_SIZE = 16
local COLOR_MARGIN = 2

function scene:create()
    scene.color = gfx.COLOR_BLACK

    local colors_group = display.new_group()
    scene:insert(colors_group)
    local pixels_group = display.new_group()
    scene:insert(pixels_group)

    local pixels = {}
    local selected_x, selected_y = 1, 1
    local colors = {}
    local selected_color = 1

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

    local function on_pixel_mouse_press(event)
        local pixel = event.target
        select_pixel(pixel.col, pixel.row)
        pixel:change_color()
    end
    
    for y = 1, GRID_HEIGHT do
        pixels[y] = { }
        for x = 1, GRID_WIDTH do
            local pixel = display.new_rect((x - 1) * (PIXEL_SIZE + PIXEL_MARGIN) + (PIXEL_SIZE + PIXEL_MARGIN) / 2, (y - 1) * (PIXEL_SIZE + PIXEL_MARGIN) + (PIXEL_SIZE + PIXEL_MARGIN) / 2, PIXEL_SIZE, PIXEL_SIZE)
            pixel.color = PIXEL_COLOR
            pixel.is_selected = false
            pixel.stroke_color = PIXEL_SELECTION_COLOR
            pixel.col = x
            pixel.row = y

            function pixel:select()
                self.is_selected = true
                self.stroke_width = PIXEL_SELECTION_WIDTH
                if self.color == PIXEL_SELECTION_COLOR then
                    self.stroke_color = gfx.COLOR_RED
                else
                    self.stroke_color = PIXEL_SELECTION_COLOR
                end
            end

            function pixel:deselect()
                self.is_selected = false
                self.stroke_width = 0
            end

            function pixel:change_color()
                self.color = selected_color
                if self.color == PIXEL_SELECTION_COLOR then
                    self.stroke_color = gfx.COLOR_RED
                else
                    self.stroke_color = PIXEL_SELECTION_COLOR
                end
            end

            pixel:add_event_listener(pixel.EVENTS.MOUSE_PRESSED, input.MOUSE_LEFT, on_pixel_mouse_press)

            pixels_group:insert(pixel)
            pixels[y][x] = pixel
        end
    end

    pixels_group.y = (display.CONTENT_HEIGHT - (GRID_HEIGHT * (PIXEL_SIZE + PIXEL_MARGIN) - PIXEL_MARGIN)) / 2
    pixels_group.x = pixels_group.y

    local function select_color(index)
        local previous_color = colors[selected_color]
        previous_color:deselect()
        selected_color = index
        local color = colors[selected_color]
        color:select()
    end

    local function on_color_mouse_press(event)
        local color = event.target
        select_color(color.color)
    end

    local index = 0
    for y = 1, 8 do
        for x = 1, 2 do
            index = index + 1
            local item = display.new_rect((x - 1) * (COLOR_SIZE + COLOR_MARGIN) + (COLOR_SIZE + COLOR_MARGIN) / 2, (y - 1) * (COLOR_SIZE + COLOR_MARGIN) + (COLOR_SIZE + COLOR_MARGIN) / 2, COLOR_SIZE, COLOR_SIZE)
            item.color = index
            item.is_selected = false

            function item:select()
                self.is_selected = true
                self.stroke_width = PIXEL_SELECTION_WIDTH
                if self.color == PIXEL_SELECTION_COLOR then
                    self.stroke_color = gfx.COLOR_RED
                else
                    self.stroke_color = PIXEL_SELECTION_COLOR
                end
            end

            function item:deselect()
                self.is_selected = false
                self.stroke_width = 0
            end

            item:add_event_listener(item.EVENTS.MOUSE_PRESSED, input.MOUSE_LEFT, on_color_mouse_press)
            colors_group:insert(item)
            colors[index] = item
        end
    end
    colors_group.y = pixels_group.y - 1
    colors_group.x = display.CONTENT_WIDTH - 32 - pixels_group.y

    select_pixel(1, 1)
    select_color(1)

    local function on_input_right(event)
        select_pixel(math.min(selected_x + 1, GRID_WIDTH), selected_y)
    end

    local function on_input_left(event)
        select_pixel(math.max(selected_x - 1, 1), selected_y)
    end

    local function on_input_down(event)
        select_pixel(selected_x, math.min(selected_y + 1, GRID_HEIGHT))
    end

    local function on_input_up(event)
        select_pixel(selected_x, math.max(selected_y - 1, 1))
    end

    local function on_input_back(event)
        display.go_to_scene("menu_scene")
    end

    local function on_input_next_color(event)
        local new_color = selected_color + 1
        if new_color > 16 then
            new_color = 1
        end
        select_color(new_color)
    end

    local function on_input_draw(event)
        local pixel = get_selected_pixel()
        pixel:change_color()
    end

    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.RIGHT, on_input_right)
    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.LEFT, on_input_left)
    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.DOWN, on_input_down)
    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.UP, on_input_up)

    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.BTN2, on_input_back)
    scene:add_event_listener(scene.EVENTS.KEY_PRESSED, input.KEY_BACKSPACE, on_input_back)
    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.BTN3, on_input_next_color)
    scene:add_event_listener(scene.EVENTS.INPUT_PRESSED, input.BTN1, on_input_draw)
end

return scene