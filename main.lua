function love.load()
  CELLSIZE=32
  PLAYERSIZE=16
  CELLPOS =1

  Player={x=92, y=100, G=-100, S=100, jumping=false, falling=false, Cells={}}
  Slab ={S=100}
  createMap()
end

function love.update(dt)
  playermove(dt)
  slabmove(dt)
end

function love.draw()
  

  love.graphics.setColor(255,255,255)
  ---for y=1,#map do
    p = (map[1][2][2]*CELLSIZE)-map[1][2][1]
   -- print(p)
    for y,v in ipairs(map) do
      
    --for x=1,#map[y] do
      for x,v in ipairs(map[y][1]) do
      if map[y][1][x] == 1 then
        y_pos = (map[y][2][2]*CELLSIZE)-map[y][2][1]
        love.graphics.rectangle("fill",x*CELLSIZE,y_pos,CELLSIZE,CELLSIZE)
      else
        if DEBUG then
          love.graphics.rectangle("line",x*CELLSIZE,(y_pos+CELLPOS)*CELLSIZE,CELLSIZE,CELLSIZE)
        end
      end
    end
   
  end
  love.graphics.setColor(255,0,0,128)
  love.graphics.rectangle("fill",Player.x,Player.y,PLAYERSIZE, PLAYERSIZE)
  if DEBUG then
    love.graphics.setColor(0,255,0)
    love.graphics.print(string.format("Player at (%06.2f , %06.2f) jumping=%s falling=", Player.x, Player.y, tostring(Player.jumping), tostring(Player.falling)), 50,0)
    love.graphics.print(string.format("Player occupies cells(%d): %s", #Player.Cells, table.concat(Player.Cells, ' | ')), 450,0)
  end
end

-- is user off map?
function isOffMap(x, y)
  if x<CELLSIZE or x+PLAYERSIZE> (1+#map[1][1])*CELLSIZE
   or y<CELLSIZE or y+PLAYERSIZE>(1+#map)*CELLSIZE 
  then
    return true
  else
    return false
  end
end

function createMap()
  map = {
      {{1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,1}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,2}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,3}},
      {{0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},{1,4}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,5}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,6}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0},{1,7}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,8}},
      {{0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,9}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,10}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,11}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,12}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,13}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,14}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,15}},
      {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,16}},
      {{0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{1,17}},
      {{0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},{1,18}},
      {{1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1},{1,19}},
  }
end

-- which tile is that?
function posToTile(x, y)
  local tx=math.floor(x/CELLSIZE)
  local ty=math.floor(y/CELLSIZE)
  return tx, ty
end

-- Find out which cells are occupied by a player (check for each corner)
function playerOnCells(x, y)
  local Cells={}
  local tx,ty=posToTile(x, y)
  local key=tx..','..ty
  Cells[key]=true
  Cells[#Cells+1]=key

  tx,ty=posToTile(x+PLAYERSIZE, y)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end

  tx,ty=posToTile(x+PLAYERSIZE, y+PLAYERSIZE)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end

  tx,ty=posToTile(x, y+PLAYERSIZE)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end
  return Cells
end

local isDown = love.keyboard.isDown
function playermove(dt)
  -- Moving right or left?
  local newX, newY
  if isDown("left") then
    newX=Player.x-Player.S*dt
  end
  if isDown("right") then
    newX=Player.x+Player.S*dt
  end
  if newX then -- trying to move to a side
    local offmap=isOffMap(newX, Player.y)
    local colliding=isColliding(playerOnCells(newX, Player.y))
    if not offmap and not colliding then
      Player.x=newX
    end
  end

  -- jumping up or falling down
  Player.G = Player.G + Player.S*dt

  if not Player.jumping and isDown(" ") and not Player.falling then
    Player.jumping = true 
    Player.G = -100
  end

    -- check only for upper or lower collision
  newY= Player.y + Player.G*dt -- always falling

  local coll=isColliding(playerOnCells(Player.x, newY))
  if coll then
    if Player.G>=0 then -- falling down on the ground
      
      Player.jumping=false
      Player.falling=false
    end

    Player.G=0
    
  else
    Player.falling=true -- falling down
  end

  if not isOffMap(Player.x, newY) and not coll then
    Player.y=newY
  end
  if DEBUG then
    Player.Cells=playerOnCells(Player.x, Player.y) -- 
  end
end

-- list of tiles


function slabmove(dt)
  local slab_y
  local temp_map
  slab_y = map[1][2][1]
  print(1) 
  if slab_y >0 then
     temp_map = table.remove(map,1)
     temp_map[2][2] = #map+1
     map[#map+1] = temp_map

  end      
	for k,v in ipairs(map) do
     
	   map[k][2][1] = map[k][2][1]+(Slab.S*dt)
	end
end  


function isColliding(T)
  local collision=false
  for k,v in ipairs(T) do
    local x,y=v:match('(%d+),(%d+)')
    x,y=tonumber(x), tonumber(y)
    if not map[y] or not map[y][1][x] then
      collision=true -- off-map
    elseif map[tonumber(y)][1][tonumber(x)] == 1 then
     
      collision=true
    end
  end
  return collision
end







function love.keypressed(k)
  if k=='escape' then
    love.event.quit()
  end
  if k=='d' then DEBUG=not DEBUG end
end

