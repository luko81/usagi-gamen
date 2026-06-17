local sprite_object = require("usagigamen.display.sprite")

-- Parameters:
-- x, y - position (default 0)
-- options - table with additional options for sprite_object and display_object
local function new_animated_sprite_object(x, y, options)
    local sprite = sprite_object.new_sprite_object(x, y, 0, options)

    local sequences = {}
    local current_sequence = nil
    local time_accumulator = 0

    function sprite:add_sequence(name, options)
        local sequence = {
            name = name,
            fps = options.fps or 6,
            _current_frame_index = 1,
        }
        if options.loop == nil then
            sequence.loop = true
        else
            sequence.loop = options.loop
        end
        if options.frames and #options.frames > 0 then
            sequence.frames = options.frames
        else
            if options.start and options.count then
                sequence.frames = {}
                for i = 1, options.count do
                    sequence.frames[i] = options.start + i - 1
                end
            else
                error("Animated sprite sequence must have either frames or start and count options")
            end 
        end
        sequences[name] = sequence
    end

    function sprite:play(name)
        if current_sequence and current_sequence.name == name then
            return
        end
        if sequences[name] then
            current_sequence = sequences[name]
            current_sequence._current_frame_index = 1
            self.frame_index = current_sequence.frames[current_sequence._current_frame_index]
            time_accumulator = 0
        else
            error("Animated sprite sequence not found: " .. name)
        end
    end

    function sprite:_update_animated_sprite(dt)
        if current_sequence then
            time_accumulator = time_accumulator + dt
            if time_accumulator > 1 / current_sequence.fps then
                current_sequence._current_frame_index = current_sequence._current_frame_index + 1
                if current_sequence._current_frame_index > #current_sequence.frames then
                    if current_sequence.loop then
                        current_sequence._current_frame_index = 1
                    else
                        current_sequence._current_frame_index = #current_sequence.frames
                    end
                end
                self.frame_index = current_sequence.frames[current_sequence._current_frame_index]
                time_accumulator = time_accumulator - 1 / current_sequence.fps
            end
        end
    end

    function sprite:_update_display_object(dt)
        self:_update_animated_sprite(dt)
    end

    return sprite
end

return {
    new_animated_sprite_object = new_animated_sprite_object,
}