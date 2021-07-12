local sprites = require 'sprites'
local sceneGameplay = require 'scene_gameplay'

return function ()
  local s = {}

  s.press = function (x, y)
  end

  s.move = function (x, y)
  end

  s.release = function (x, y)
    -- sprites.delete('game_start')
    _G['replaceScene'](sceneGameplay(1))
  end

  s.update = function ()
  end

  s.draw = function ()
    sprites.draw('game_start', 0, 0, W, H)
  end

  return s
end
