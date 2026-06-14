local transition = { }

-- Active transitions. Reset on hot reload, like timer's transition table.
local transitions = { }

-- Properties that can be tweened. Only the ones present in params are animated.
local TRANSITION_PROPERTIES = { "x", "y", "width", "height", "alpha", "scale" }

-- Parameters:
-- target - display object (or any table) whose properties are tweened
-- params:
--   time - milliseconds the tween runs (default 500)
--   delay - milliseconds to wait before starting (default 0)
--   x, y, width, height, alpha, scale - destination values; only the ones provided are animated
--   tag - optional string used to group transitions for cancel/pause/resume
--   on_complete - optional function(target) called when the tween finishes
local function create_transition_object(target, params)
    local t = {
        _target = target,
        _time = params.time or 500,
        _delay = params.delay or 0,
        _tag = params.tag,
        _on_complete = params.on_complete,
        _elapsed = 0,    -- ms accumulated into the tween (after the delay)
        _started = false,
        _paused = false,
        _cancelled = false,
        _from = { },     -- start values, captured when the tween begins
        _to = { },       -- destination values
        _props = { },    -- list of property names being animated
    }
    for _, prop in ipairs(TRANSITION_PROPERTIES) do
        if params[prop] ~= nil then
            t._props[#t._props + 1] = prop
            t._to[prop] = params[prop]
        end
    end
    return t
end

-- Capture start values lazily so the tween animates from wherever the target
-- is once its delay has elapsed, not from where it was when scheduled.
local function start(t)
    t._started = true
    for _, prop in ipairs(t._props) do
        t._from[prop] = t._target[prop] or 0
    end
end

local function apply(t, progress)
    local target = t._target
    for _, prop in ipairs(t._props) do
        local from = t._from[prop]
        target[prop] = from + (t._to[prop] - from) * progress
    end
end

-- Matches a transition against a transition object, its target, or a tag string.
local function matches(t, object_or_tag)
    if type(object_or_tag) == "string" then
        return t._tag == object_or_tag
    end
    return t == object_or_tag or t._target == object_or_tag
end

local function set_paused(object_or_tag, paused)
    for _, t in ipairs(transitions) do
        if matches(t, object_or_tag) then t._paused = paused end
    end
end

transition.to = function(target, params)
    local t = create_transition_object(target, params)
    transitions[#transitions + 1] = t
    return t
end

transition.cancel = function(object_or_tag)
    for _, t in ipairs(transitions) do
        if matches(t, object_or_tag) then t._cancelled = true end
    end
end

transition.cancel_all = function()
    for _, t in ipairs(transitions) do t._cancelled = true end
end

transition.pause = function(object_or_tag)
    set_paused(object_or_tag, true)
end

transition.pause_all = function()
    for _, t in ipairs(transitions) do t._paused = true end
end

transition.resume = function(object_or_tag)
    set_paused(object_or_tag, false)
end

transition.resume_all = function()
    for _, t in ipairs(transitions) do t._paused = false end
end

function transition:_update(dt)
    local dt_ms = dt * 1000

    -- Snapshot so on_complete callbacks that add transitions don't get advanced
    -- this frame.
    local snapshot = { }
    for i = 1, #transitions do snapshot[i] = transitions[i] end

    for _, t in ipairs(snapshot) do
        if not t._cancelled and not t._paused then
            local advance = dt_ms

            -- Consume the initial delay; any leftover time spills into the tween.
            if t._delay > 0 then
                t._delay = t._delay - advance
                if t._delay > 0 then
                    advance = 0
                else
                    advance = -t._delay
                    t._delay = 0
                end
            end

            if t._delay <= 0 then
                if not t._started then start(t) end

                t._elapsed = t._elapsed + advance
                local progress
                if t._time <= 0 then
                    progress = 1
                else
                    progress = t._elapsed / t._time
                    if progress > 1 then progress = 1 end
                end
                apply(t, progress)

                if progress >= 1 then
                    t._cancelled = true
                    if t._on_complete then t._on_complete(t._target) end
                end
            end
        end
    end

    -- Compact: drop cancelled transitions in place, preserving order.
    local n = 0
    for i = 1, #transitions do
        local t = transitions[i]
        if not t._cancelled then
            n = n + 1
            transitions[n] = t
        end
    end
    for i = #transitions, n + 1, -1 do transitions[i] = nil end
end

return transition
