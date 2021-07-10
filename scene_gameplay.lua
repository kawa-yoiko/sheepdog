local Board = require 'board'
local buttons = require 'buttons'

local BORDER_PAD = 12
local ITEM_SIZE = 60
local ITEM_SPACE = 12
local STORE_WIDTH = ITEM_SIZE + BORDER_PAD * 2
local CELL_SIZE = 40

return function ()
  local s = {}

  local board = Board.create(1)

  local btnsStorehouse = buttons()
  for i = 1, 5 do
    btnsStorehouse.add(
      BORDER_PAD,
      BORDER_PAD + (ITEM_SIZE + ITEM_SPACE) * (i - 1),
      ITEM_SIZE, ITEM_SIZE,
      'ice-cream_1f368.png',
      function () print('item ' .. i) end
    )
  end

  s.press = function (x, y)
    if btnsStorehouse.press(x, y) then return end
  end

  s.move = function (x, y)
    if btnsStorehouse.move(x, y) then return end
  end

  s.release = function (x, y)
    if btnsStorehouse.release(x, y) then return end
  end

  s.update = function ()
    btnsStorehouse.update()
    board.update()
  end

  local xStart = (W + STORE_WIDTH) / 2 - CELL_SIZE * board.w / 2
  local yStart = H / 2 - CELL_SIZE * board.h / 2

  local function drawSheep(sh)
    local prog = sh.prog / Board.CELL_SUBDIV
    local r = sh.from[1] * (1 - prog) + sh.to[1] * prog
    local c = sh.from[2] * (1 - prog) + sh.to[2] * prog
    local xCen = xStart + (c - 0.5) * CELL_SIZE
    local yCen = yStart + (r - 0.5) * CELL_SIZE
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', xCen, yCen, 10)
  end

  s.draw = function ()
    btnsStorehouse.draw()
    for r = 1, board.h do
      for c = 1, board.w do
        if board.grid[r][c] == Board.ENTRY then
          love.graphics.setColor(1.0, 0.85, 0.7)
        elseif (r + c) % 2 == 0 then
          love.graphics.setColor(0.65, 0.85, 0.55)
        else
          love.graphics.setColor(0.55, 0.75, 0.48)
        end
        local xCell = xStart + (c - 1) * CELL_SIZE
        local yCell = yStart + (r - 1) * CELL_SIZE
        love.graphics.rectangle('fill', xCell, yCell, CELL_SIZE, CELL_SIZE)
        if board.grid[r][c] >= Board.PATH then
          local pts = {{0.5, 0}, {1, 0.5}, {0.5, 1}, {0, 0.5}}
          love.graphics.setColor(1.0, 0.8, 0.2)
          love.graphics.setLineWidth(5)
          for k = 1, 4 do
            if bit.band(board.grid[r][c], bit.lshift(1, k - 1)) ~= 0 then
              love.graphics.line(
                xCell + CELL_SIZE * 0.5,
                yCell + CELL_SIZE * 0.5,
                xCell + CELL_SIZE * pts[k][1],
                yCell + CELL_SIZE * pts[k][2]
              )
            end
          end
        end
      end
    end
    for _, sh in ipairs(board.sheep) do drawSheep(sh) end
    love.graphics.setColor(1, 1, 1)
  end

  return s
end
