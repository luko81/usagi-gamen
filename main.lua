local display = require("usagigamen.display")

function _config()
  ---@type Usagi.Config
  return { name = "Game", game_id = "com.usagiengine.usagigamen", sprite_size = 32, }
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

function _draw(dt)
  display:draw(dt)
end

display.reload() -- Go to the last scene on hot reload