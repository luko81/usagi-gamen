local display_defaults = require("usagigamen.display.defaults")
local event_handler_object = require("usagigamen.display.input_event_handler")

-- Parameters:
-- options:
-- parent - parent group_object
-- x, y - position
-- width, height - size
-- anchor_x, anchor_y - anchor point (0 to 1, default 0.5)
local function new_display_object(options)

    options = options or { }

    local display_object = { }
    local event_handler = nil

    display_object.EVENTS = event_handler_object.EVENTS

    function display_object:_property_changed(key, value)
        -- Override in subclasses.
    end
    
    local props = { }
    setmetatable(display_object, {
        __index = props,
        __newindex = function(t, key, value)
            props[key] = value
            if type(value) ~= "function" and type(value) ~= "table" then
                display_object:_property_changed(key, value)
            end
        end,
    })

    if options.parent then
        options.parent._children[#options.parent._children + 1] = display_object
        display_object._parent = options.parent
    end

    display_object.x = options.x or 0
    display_object.y = options.y or 0
    display_object.width = options.width or 0
    display_object.height = options.height or 0
    display_object.anchor_x = options.anchor_x or display_defaults.anchor_x
    display_object.anchor_y = options.anchor_y or display_defaults.anchor_y

    function display_object:_update_event_handler(dt)
        if event_handler then
            event_handler:update(dt)
        end
    end

    function display_object:_update_display_object(dt)
        self:_update_event_handler(dt)
    end

    function display_object:_update(dt)
        -- Override in subclasses.
    end

    function display_object:_validate()
        if self.width < 0 then self.width = 0 end
        if self.height < 0 then self.height = 0 end
    end

    function display_object:update(dt)
        self:_update_display_object(dt)
        self:_update(dt)
        self:_validate()
    end

    function display_object:_draw_display_object(dt)
        -- Override in subclasses.
    end

    function display_object:_draw(dt)
        -- Override in subclasses.
    end

    function display_object:draw(dt)
        self:_draw_display_object(dt)
        self:_draw(dt)
    end

    function display_object:local_to_content(x, y)
        local parent = self._parent
        if parent then
            return parent:local_to_content(x + parent.x, y + parent.y)
        end
        return x, y
    end

    function display_object:destroy()
        local parent = self._parent
        if parent then
            parent:remove_child(self)
            self._parent = nil
        end
    end

    function display_object:to_back()
        local parent = self._parent
        if not parent then return end
        for i, child in ipairs(parent._children) do -- move to group_obect
            if child == self then
                table.remove(parent._children, i)
                table.insert(parent._children, 1, self)
                return
            end
        end
    end

    function display_object:to_front()
        local parent = self._parent
        if not parent then return end
        for i, child in ipairs(parent._children) do -- move to group_obect
            if child == self then
                table.remove(parent._children, i)
                table.insert(parent._children, self)
                return
            end
        end
    end

    function display_object:add_event_listener(event_name, key_or_button, listener)
        if not event_handler then
            event_handler = event_handler_object.new_event_handler(self)
        end
        event_handler:add_event_listener(event_name, key_or_button, listener)
    end

    function display_object:remove_event_listener(event_name, key_or_button, listener)
        if not event_handler then return end
        event_handler:remove_event_listener(event_name, key_or_button, listener)
    end

    return display_object
end

return {
    new_display_object = new_display_object,
}
