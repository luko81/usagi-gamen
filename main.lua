local display = require("usagigamen.display")

function _config()
  ---@type Usagi.Config
  return { name = "Game", game_id = "com.usagiengine.usagigamen" }
end

function _init()
  -- Live reload preserves globals across saved edits but resets locals.
  -- Stash mutable game state in a capitalized global like `State` so it
  -- survives reloads; F5 calls _init again to reset.
  State = {}

  display.go_to_scene("menu_scene")
end

function _update(dt)
  display:update(dt)
end

local time = 0
function _draw(dt)
  -- gfx.clear(gfx.COLOR_DARK_PURPLE)
  -- gfx.text("Hello, Usagi!", 10, 10, gfx.COLOR_WHITE)
  -- gfx.rect_fill(display.CONTENT_CENTER_X - 25, display.CONTENT_CENTER_Y - 25, -50, -50, gfx.COLOR_PEACH)

  display:draw(dt)
end

display.reload() -- Go to the last scene on hot reload