local Board = {
  -- cell types
  EMPTY = 0,
  OBSTACLE = 1,

  PATH = 256,
  -- bits 0, 1, 2, 3: path N/E/S/W
  -- bits 4, 5, 6, 7: dog (4-bit integer, 1-4 denotes direction N/E/S/W)
  -- higher bits: type

  TYPE_ORDINARY_PATH = 1,
  TYPE_SHEEPFOLD = 5, -- flock index = type - TYPE_SHEEPFOLD + 1
  TYPE_SHEEPFOLD_MAX = 5 + 16 - 1,

  CELL_SUBDIV = 60,
}

local MOVE = {
  [0] = {-1, 0}, {0, 1}, {1, 0}, {0, -1}
}
local function move(from, dir)
  return from[1] + MOVE[dir][1], from[2] + MOVE[dir][2]
end

local popcountTable = {
  [0] = 0, 1, 1, 2, 1, 2, 2, 3,
        1, 2, 2, 3, 2, 3, 3, 4,
}
local function popcount4(x)
  return popcountTable[x % 16]
end
local function ctz4(x)
  if x == 1 then return 0
  elseif x == 2 then return 1
  elseif x == 4 then return 2
  elseif x == 8 then return 3
  else return -1 end
end

function Board.create(level)
  local w, h = 16, 10
  local grid = {}
  for r = 1, h do
    grid[r] = {}
    for c = 1, w do grid[r][c] = Board.EMPTY end
  end
  grid[10][1] = Board.PATH + 2 + 8
  grid[10][2] = Board.PATH + 1 + 8
  grid[9][2] = Board.PATH + 1 + 4
  grid[8][2] = Board.PATH + 1 + 4
  grid[7][2] = Board.PATH + 1 + 4
  grid[6][2] = Board.PATH + 1 + 4
  grid[5][2] = Board.PATH + 1 + 4
  grid[4][2] = Board.PATH + 1 + 4
  grid[3][2] = Board.PATH + 2 + 4
  grid[3][3] = Board.PATH + 1 + 8
  grid[2][3] = Board.PATH + 2 + 4
  grid[2][4] = Board.PATH + 2 + 8
  grid[2][5] = Board.PATH + 4 + 8
  grid[3][5] = Board.PATH + 1 + 4
  grid[4][5] = Board.PATH + 1 + 2 + 8 + 2*16
  grid[4][4] = Board.PATH + 2 + 8
  grid[4][6] = Board.PATH + 1 + 8
  grid[3][6] = Board.PATH + 1 + 4
  grid[2][6] = Board.PATH + 1 + 4
  grid[1][6] = Board.PATH + 15 + 4*16
  grid[1][7] = Board.PATH + 2 + 8
  grid[1][5] = Board.PATH + 2 + 8
  grid[1][4] = Board.PATH + 2 + 8
  grid[1][3] = Board.PATH + 2 + 8
  grid[1][2] = Board.PATH + 2 + 8
  grid[1][1] = Board.PATH * Board.TYPE_SHEEPFOLD + 2
  grid[5][5] = Board.PATH + 1 + 2 + 4 + 3*16
  grid[6][5] = Board.PATH + 1 + 2 + 4 + 1*16

  local sheep = {}
  -- flock: flock index
  -- eta: time until arrival
  -- from: {row, col}
  -- to: {row, col}
  -- dir: 0-3 = N/E/S/W
  -- prog: 0 = at <from>, Board.CELL_SUBDIV = at <to>
  -- sheepfold: whether already in the sheepfold
  for i = 1, 5 do
    sheep[#sheep + 1] = { flock = 1, eta = i * Board.CELL_SUBDIV }
  end
  for i = 1, 5 do
    sheep[#sheep + 1] = { flock = 2, eta = (i + 8) * Board.CELL_SUBDIV }
  end

  local function update()
    -- index: flock * w * h + r * w + c, value: true
    local occupy = {}

    for _, sh in ipairs(sheep) do
      if sh.eta > 0 then
        sh.eta = sh.eta - 1
        if sh.eta == 0 then
          -- Appear!
          sh.from = {h, 0}
          sh.to = {h, 1}
          sh.dir = 1
          sh.prog = 0
          sh.sheepfold = false
        end
      elseif sh.dir ~= -1 then
        sh.prog = sh.prog + 1
        if sh.prog == Board.CELL_SUBDIV then
          -- Arrived at destination!
          sh.from = sh.to
          sh.prog = 0

          -- Current cell
          local cell = grid[sh.from[1]][sh.from[2]]

          -- Next step?
          if cell < Board.PATH then
            error('Going to a non-path cell!')
          end

          -- Move
          local dir = -1
          local ty = math.floor(cell / Board.PATH)
          if ty == Board.TYPE_ORDINARY_PATH then
            -- Ordinary path
            local count = popcount4(cell)
            if count == 2 then
              -- Go to the other outlet
              dir = ctz4(bit.bxor(cell % 16, bit.lshift(1, (sh.dir + 2) % 4)))
            else
              -- Check for the dog
              local dog = bit.arshift(cell, 4) % 16
              if dog >= 1 and dog <= 4 then
                dir = dog - 1
              end
            end

          elseif ty >= Board.TYPE_SHEEPFOLD and ty <= Board.TYPE_SHEEPFOLD_MAX then
            -- Sheepfold
            local flock = ty - Board.TYPE_SHEEPFOLD + 1
            if sh.flock == flock then
              sh.sheepfold = true
            else
              error('Wrong sheepfold!')
            end
          end

          -- Check for viability
          if dir ~= -1 then
            local r1, c1 = move(sh.from, dir)

            -- Destination has no corresponding inlet?
            if r1 < 1 or r1 > h or c1 < 1 or c1 > w or
                grid[r1][c1] < Board.PATH or
                bit.band(grid[r1][c1] % 16, bit.lshift(1, (dir + 2) % 4)) == 0
            then
              dir = -1

            -- Blocked by another sheep in the same flock?
            elseif occupy[sh.flock * w * h + r1 * w + c1] then
              dir = -1
            end
          end
          -- Move
          sh.dir = dir
          if dir ~= -1 then
            local r1, c1 = move(sh.from, dir)
            sh.to = {r1, c1}
            occupy[sh.flock * w * h + r1 * w + c1] = true
          elseif not sh.sheepfold then
            occupy[sh.flock * w * h + sh.from[1] * w + sh.from[2]] = true
          end
        end
      end
    end
  end

  return {
    w = w, h = h,
    grid = grid,
    sheep = sheep,
    update = update,
  }
end

return Board
