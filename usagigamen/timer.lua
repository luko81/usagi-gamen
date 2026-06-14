local timer = { }

-- Active timer objects. Reset on hot reload, like display's scene table.
local timers = { }

-- Parameters:
-- delay - milliseconds between fires
-- listener - function(event) or a table with a :timer(event) method
-- iterations - number of fires (default 1); <= 0 means repeat indefinitely
-- tag - optional string used to group timers for cancel/pause/resume
local function create_timer_object(delay, listener, iterations, tag)
    iterations = iterations or 1
    if iterations <= 0 then iterations = math.huge end
    return {
        _delay = delay,
        _listener = listener,
        _iterations = iterations,
        _tag = tag,
        _elapsed = 0,    -- ms accumulated toward the next fire
        _count = 0,      -- fires so far
        _paused = false,
        _cancelled = false,
    }
end

local function fire(t)
    local listener = t._listener
    local event = {
        source = t,
        count = t._count,
        time = t._count * t._delay,
    }
    if type(listener) == "function" then
        listener(event)
    elseif type(listener) == "table" and type(listener.timer) == "function" then
        listener:timer(event)
    end
end

-- Returns the milliseconds remaining before the timer's next fire.
local function remaining(t)
    return t._delay - t._elapsed
end

timer.perform_with_delay = function(delay, listener, iterations, tag)
    local t = create_timer_object(delay, listener, iterations, tag)
    timers[#timers + 1] = t
    return t
end

timer.cancel = function(object_or_tag)
    if type(object_or_tag) == "table" then
        object_or_tag._cancelled = true
        return remaining(object_or_tag)
    end
    for _, t in ipairs(timers) do
        if t._tag == object_or_tag then t._cancelled = true end
    end
end

timer.cancel_all = function()
    for _, t in ipairs(timers) do t._cancelled = true end
end

timer.pause = function(object_or_tag)
    if type(object_or_tag) == "table" then
        object_or_tag._paused = true
        return remaining(object_or_tag)
    end
    for _, t in ipairs(timers) do
        if t._tag == object_or_tag then t._paused = true end
    end
end

timer.pause_all = function()
    for _, t in ipairs(timers) do t._paused = true end
end

timer.resume = function(object_or_tag)
    if type(object_or_tag) == "table" then
        object_or_tag._paused = false
        return remaining(object_or_tag)
    end
    for _, t in ipairs(timers) do
        if t._tag == object_or_tag then t._paused = false end
    end
end

timer.resume_all = function()
    for _, t in ipairs(timers) do t._paused = false end
end

function timer:_update(dt)
    local dt_ms = dt * 1000

    -- Snapshot so listeners that add timers don't get advanced this frame.
    local snapshot = { }
    for i = 1, #timers do snapshot[i] = timers[i] end

    for _, t in ipairs(snapshot) do
        if not t._cancelled and not t._paused then
            t._elapsed = t._elapsed + dt_ms
            -- Catch up if more than one period elapsed in a single frame.
            while not t._cancelled and not t._paused and t._elapsed >= t._delay do
                t._elapsed = t._elapsed - t._delay
                t._count = t._count + 1
                fire(t)
                if t._count >= t._iterations then
                    t._cancelled = true
                end
            end
        end
    end

    -- Compact: drop cancelled timers in place, preserving order.
    local n = 0
    for i = 1, #timers do
        local t = timers[i]
        if not t._cancelled then
            n = n + 1
            timers[n] = t
        end
    end
    for i = #timers, n + 1, -1 do timers[i] = nil end
end

return timer
