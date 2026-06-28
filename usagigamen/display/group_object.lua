local display_object = require("usagigamen.display.display_object")

-- Parameters:
-- options: same as display_object.new_display_object
local function new_group_object(options)
    local group_object = display_object.new_display_object(options)
    group_object._children = { }

    function group_object:_update_children(dt)
        for _, child in ipairs(self._children) do
            child:update(dt)
        end
    end

    function group_object:_update_display_object(dt)
        self:_update_event_handler(dt)
        self:_update_children(dt)
    end

    function group_object:_draw_children(dt)
        for _, child in ipairs(self._children) do
            child:draw(dt)
        end
    end

    function group_object:_draw_display_object(dt)
        self:_draw_children(dt)
    end

    function group_object:remove_child(child)
        for i, c in ipairs(self._children) do
            if c == child then
                table.remove(self._children, i)
                return true
            end
        end
        return false
    end

    function group_object:insert(child)
        if child._parent then
            child._parent:remove_child(child)
        end
        self._children[#self._children + 1] = child
        child._parent = self
    end

    return group_object
end

return {
    new_group_object = new_group_object,
}