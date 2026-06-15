# 🐰 Usagi Gamen

> A Solar2D-inspired display framework for the [Usagi Engine](https://usagiengine.com).
> Scenes, display objects, groups, timers, and transitions — the cozy stuff.

*Gamen* (画面) is Japanese for "screen." *Usagi* (うさぎ) is "rabbit." So this is,
roughly, "rabbit screen." It made sense at the time.

## What is this?

Usagi is a lovely little 2D engine, but it hands you a `gfx.*` API and says "good
luck." That's great — until the third time you write the same "loop over my
sprites and draw them in order" boilerplate and start muttering about scene
graphs.

Usagi Gamen is that scene graph. If you've ever touched Corona / Solar2D, you'll
feel right at home: you make a **scene**, you `display.new_*` some things into it,
you `transition.to` them around, and you schedule stuff with `timer`. The engine
loop calls `update` and `draw`, and the tree sorts itself out.

## ⚠️ The fine print

This was built over a weekend. It is **probably not stable**. The API may change, there are sharp edges, and the TODO list is still longer than the feature list. But it's genuinely fun to play with, and that was the whole point.

## Requirements

- The [Usagi Engine](https://usagiengine.com).
- That's it. Usagi Gamen is pure Lua that rides on top of Usagi's `gfx` / `input`.

## Quick start

Clone this repo and run it from the project root:

```sh
usagi dev
```

You'll land on a little menu scene. Arrow keys to move, `Z` select, `X` back (or gamepad), and poke around the examples.

Minimal `main.lua`:

```lua
local display = require("usagigamen.display")

function _config()
  return { name = "Game", game_id = "com.example.mygame" }
end

function _init()
  State = {}
  display.go_to_scene("menu_scene")
end

function _update(dt) display:update(dt) end
function _draw(dt)   display:draw(dt)   end

display.reload() -- jump back to the last scene on hot reload
```

## Core ideas

### Scenes

A scene is a container you switch between. Define `create`, then add things to
it. `display.go_to_scene(name)` lazily `require`s `name`, calls `create` once,
and runs the optional `show` / `hide` hooks.

```lua
local display = require("usagigamen.display")
local scene = display.new_scene()

function scene:create()
  scene.color = gfx.COLOR_DARK_PURPLE
  local text = display.new_text(display.CONTENT_CENTER_X, 40, "Hello, Gamen!")
  text.scale = 2
  scene:insert(text)
end

function scene:_update(dt)
  -- per-frame scene logic; input lives here
end

return scene
```

### Display objects

`display.new_rect`, `display.new_circ`, `display.new_text`, `display.new_group`.
Set properties directly (`obj.x`, `obj.y`, `obj.color`, `obj.alpha`,
`obj.scale`, …) and they just render. Objects know `:destroy()`, `:to_front()`,
`:to_back()`, and `:local_to_content(x, y)`.

```lua
local rect = display.new_rect(100, 50, 32, 32, gfx.COLOR_PEACH)
rect.stroke_color = gfx.COLOR_WHITE
rect.stroke_width = 1
scene:insert(rect)
```

### Groups

`display.new_group()` is a movable container. Move the group and its children
follow. Handy for menus, HUDs, and anything you want to position as a unit.

### Timers

Solar2D-style, snake_cased. Delays are in **milliseconds**.

```lua
local timer = require("usagigamen.timer")

-- fire once after 1s
timer.perform_with_delay(1000, function() print("ding") end)

-- fire 5 times, every 500ms, tagged so you can cancel the batch
local t = timer.perform_with_delay(500, on_tick, 5, "spawner")

timer.pause(t)          -- or timer.pause("spawner")
timer.resume("spawner")
timer.cancel(t)         -- 0 or negative iterations = repeat forever
timer.cancel_all()
```

### Transitions

Linear tweens of `x`, `y`, `width`, `height`, `alpha`, and `scale`. No easing —
just honest straight lines. Times in **milliseconds**.

```lua
local transition = require("usagigamen.transition")

transition.to(rect, { x = 300, y = 80, time = 1000 })
transition.to(text, { scale = 2, time = 300, delay = 200,
                      on_complete = function(t) print("done") end })

-- cancel/pause/resume by transition handle, target object, or tag
local handle = transition.to(rect, { alpha = 0, time = 500, tag = "fade" })
transition.cancel(handle)   -- or transition.cancel(rect), or transition.cancel("fade")
transition.cancel_all()
```

## Examples

Runnable demos live under [`examples/`](examples/) and are reachable from the
default menu scene:

- **Display Objects** — rects, circles, text, groups.
- **Switching Scenes** — `go_to_scene`, `show` / `hide`.
- **Transitions and Timers** — tweens, repeating timers, spawning + destroying.
- **Pixel Paint** — a tiny paint toy, mouse + display objects.

## Library map

The whole framework lives under [`usagigamen/`](usagigamen/):

```
usagigamen/
  display.lua        -- entry point: scenes, factories, update/draw
  timer.lua          -- perform_with_delay + cancel/pause/resume
  transition.lua     -- transition.to + cancel/pause/resume
  display/           -- the node types (display_object, shape, rect, circ, text, group, scene)
  USAGIGAMEN.md      -- API outline + TODO
```

## Credits

Built on the wonderful [Usagi Engine](https://usagiengine.com) by Brett Chalupa.
API shape lovingly borrowed from Corona / Solar2D. Bugs are mine.
