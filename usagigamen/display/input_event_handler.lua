local EVENTS = {
    INPUT_PRESSED = "input_pressed",
    INPUT_RELEASED = "input_released",
    INPUT_HELD = "input_held",
    MOUSE_PRESSED = "mouse_pressed",
    MOUSE_RELEASED = "mouse_released",
    MOUSE_HELD = "mouse_held",
    -- MOUSE_SCROLL = "mouse_scroll",
    KEY_PRESSED = "key_pressed",
    KEY_RELEASED = "key_released",
    KEY_HELD = "key_held",
}

local function new_event_handler(display_object)
    local event_handler = {
        _parent = display_object,
        _listeners = nil,
    }

    if not display_object then
        error("Event handler must be associated with a display object.")
    end

    function event_handler:add_event_listener(event_name, key_or_button, listener)
        if not key_or_button then
            error("Key or button must be specified.")
        end
        if type(listener) ~= "function" then
            error("Listener must be a function.")
        end

        if not self._listeners then self._listeners = {} end
        if not self._listeners[event_name] then self._listeners[event_name] = {} end
        if not self._listeners[event_name][tostring(key_or_button)] then self._listeners[event_name][tostring(key_or_button)] = {} end

        local listeners = self._listeners[event_name][tostring(key_or_button)]
        listeners[#listeners + 1] = { key_or_button = key_or_button, listener = listener }
    end

    function event_handler:remove_event_listener(event_name, key_or_button, listener)
        if not self._listeners[event_name] or not self._listeners[event_name][tostring(key_or_button)] then return end
        local listeners = self._listeners[event_name][tostring(key_or_button)]
        for i, l in ipairs(listeners) do
            if l.listener == listener then
                table.remove(listeners, i)
                break
            end
        end
    end

    function event_handler:_dispatch_event(event)
        if not self._listeners[event.name] or not self._listeners[event.name][tostring(event.key_or_button)] then return end
        for _, listener in ipairs(self._listeners[event.name][tostring(event.key_or_button)]) do
            listener.listener(event)
        end
    end

    function event_handler:_contains_point(mx, my)
        local x, y = self._parent:local_to_content(self._parent.x, self._parent.y)
        x = x - self._parent.width * self._parent.anchor_x
        y = y - self._parent.height * self._parent.anchor_y
        local rect = {x = x, y = y, w = self._parent.width, h = self._parent.height}
        return util.point_in_rect({x = mx, y = my}, rect)
    end

    function event_handler:update(dt)
        if self._listeners then
            -- Handle mouse events
            if self._listeners[EVENTS.MOUSE_PRESSED] or self._listeners[EVENTS.MOUSE_RELEASED] or self._listeners[EVENTS.MOUSE_HELD] then
                if input.mouse_pressed(input.MOUSE_LEFT) or input.mouse_released(input.MOUSE_LEFT) or input.mouse_held(input.MOUSE_LEFT) or
                   input.mouse_pressed(input.MOUSE_RIGHT) or input.mouse_released(input.MOUSE_RIGHT) or input.mouse_held(input.MOUSE_RIGHT) then
                    local mx, my = input.mouse()
                    if self:_contains_point(mx, my) then
                        if input.mouse_pressed(input.MOUSE_LEFT) then
                            self:_dispatch_event({name = EVENTS.MOUSE_PRESSED, key_or_button = input.MOUSE_LEFT, target = self._parent})
                        end
                        if input.mouse_released(input.MOUSE_LEFT) then
                            self:_dispatch_event({name = EVENTS.MOUSE_RELEASED, key_or_button = input.MOUSE_LEFT, target = self._parent})
                        end
                        if input.mouse_held(input.MOUSE_LEFT) then
                            self:_dispatch_event({name = EVENTS.MOUSE_HELD, key_or_button = input.MOUSE_LEFT, target = self._parent})
                        end
                        if input.mouse_pressed(input.MOUSE_RIGHT) then
                            self:_dispatch_event({name = EVENTS.MOUSE_PRESSED, key_or_button = input.MOUSE_RIGHT, target = self._parent})
                        end
                        if input.mouse_released(input.MOUSE_RIGHT) then
                            self:_dispatch_event({name = EVENTS.MOUSE_RELEASED, key_or_button = input.MOUSE_RIGHT, target = self._parent})
                        end
                        if input.mouse_held(input.MOUSE_RIGHT) then
                            self:_dispatch_event({name = EVENTS.MOUSE_HELD, key_or_button = input.MOUSE_RIGHT, target = self._parent})
                        end
                    end
                end
            end

            -- Handle keyboard events
            if self._listeners[EVENTS.KEY_PRESSED] or self._listeners[EVENTS.KEY_RELEASED] or self._listeners[EVENTS.KEY_HELD] then
                if self._listeners[EVENTS.KEY_PRESSED] then
                    for key, items in pairs(self._listeners[EVENTS.KEY_PRESSED] or {}) do
                        for _, item in ipairs(items) do
                            if input.key_pressed(item.key_or_button) then
                                self:_dispatch_event({name = EVENTS.KEY_PRESSED, key_or_button = item.key_or_button, target = self._parent})
                            end
                        end
                    end
                end
                if self._listeners[EVENTS.KEY_RELEASED] then
                    for key, items in pairs(self._listeners[EVENTS.KEY_RELEASED] or {}) do
                        for _, item in ipairs(items) do
                            if input.key_released(item.key_or_button) then
                                self:_dispatch_event({name = EVENTS.KEY_RELEASED, key_or_button = item.key_or_button, target = self._parent})
                            end
                        end
                    end
                end
                if self._listeners[EVENTS.KEY_HELD] then
                    for key, items in pairs(self._listeners[EVENTS.KEY_HELD] or {}) do
                        for _, item in ipairs(items) do
                            if input.key_held(item.key_or_button) then
                                self:_dispatch_event({name = EVENTS.KEY_HELD, key_or_button = item.key_or_button, target = self._parent})
                            end
                        end
                    end
                end
            end

            -- Handle input actions
            if self._listeners[EVENTS.INPUT_PRESSED] or self._listeners[EVENTS.INPUT_RELEASED] or self._listeners[EVENTS.INPUT_HELD] then
                if self._listeners[EVENTS.INPUT_PRESSED] then
                    for button, items in pairs(self._listeners[EVENTS.INPUT_PRESSED] or {}) do
                        for _, item in ipairs(items) do
                            if input.pressed(item.key_or_button) then
                                self:_dispatch_event({name = EVENTS.INPUT_PRESSED, key_or_button = item.key_or_button, target = self._parent})
                            end
                        end
                    end
                end
                if self._listeners[EVENTS.INPUT_RELEASED] then
                    for button, items in pairs(self._listeners[EVENTS.INPUT_RELEASED] or {}) do
                        for _, item in ipairs(items) do
                            if input.released(item.key_or_button) then
                                self:_dispatch_event({name = EVENTS.INPUT_RELEASED, key_or_button = item.key_or_button, target = self._parent})
                            end
                        end
                    end
                end
                if self._listeners[EVENTS.INPUT_HELD] then
                    for button, items in pairs(self._listeners[EVENTS.INPUT_HELD] or {}) do
                        for _, item in ipairs(items) do
                            if input.held(item.key_or_button) then
                                self:_dispatch_event({name = EVENTS.INPUT_HELD, key_or_button = item.key_or_button, target = self._parent})
                            end
                        end
                    end
                end
            end
        end
    end

    return event_handler
end

return {
    new_event_handler = new_event_handler,
    EVENTS = EVENTS,
}
