--==============================================================================================
-- MAIN
-- Contents
    -- - LOAD
        -- - Import WF
        -- - Player collidor
    -- - UPDATE
        -- - Update world update
    -- - DRAW
    -- - MISC
--==============================================================================================

--==============================================================================================
-- LOAD
--==============================================================================================

function love.load()

    -- Change window size
    love.window.setMode(1000,768)

    -- Import Anim8
    anim8 = require 'libraries/anim8/anim8'

    --import STI
    sti = require 'libraries/Simple-Tiled-Implementation/sti'

    -- Camera tool
    cameraFile = require 'libraries/hump/camera'

    -- Create Object
    cam = cameraFile()

    -- Sprites
    sprites = {}
    sprites.playersheet = love.graphics.newImage('sprites/playerSheet.png')
    sprites.enemysheet = love.graphics.newImage('sprites/enemySheet.png')

    -- Get grid of the sheet
    local grid = anim8.newGrid(614,564,sprites.playersheet:getWidth(),sprites.playersheet:getHeight())
    local enemyGrid = anim8.newGrid(100,79,sprites.enemysheet:getWidth(),sprites.enemysheet:getHeight())

    -- Animations
    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15',1),0.04) -- 1-15 is columns and 1 is the row
    animations.jump = anim8.newAnimation(grid('1-7',2),0.04)
    animations.run = anim8.newAnimation(grid('1-15',3),0.04)
    animations.enemy = anim8.newAnimation(enemyGrid('1-2',1),0.02)

    -- Import Windfield
    wf = require 'libraries/windfield/windfield' -- Import
    world = wf.newWorld(0,800,false) -- Gravity of the physics, zero gravity , direction of gravity
    world:setQueryDebugDrawing(true)

    -- Collision Classes
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')
    world:addCollisionClass('Danger')
    
    -- Import Player
    require('player')

    -- Import Enemy
    require('enemy')

    -- Enemies
    -- danger = world:newRectangleCollider(0,550,800,50,{collision_class='Danger'})
    -- danger:setType('static')

    -- Platforms
    platforms = {}

    loadMap()
end

--==============================================================================================
-- UPDATE
    -- - Player movement stuff
--==============================================================================================

function love.update(dt)
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    enemiesUpdate(dt)

    if player.body then
        -- Get player pos
        local px,py = player:getPosition()
        -- use cam to look at player
        cam:lookAt(px,love.graphics.getHeight()/2)
    end
end
--==============================================================================================
-- DRAW
--==============================================================================================

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
        world:draw()
        playerDraw()
        enemiesDraw()
    cam:detach()

end

--==============================================================================================
-- MISC FUNCTIONS
    -- -Jump
--==============================================================================================

-- Jump
function love.keypressed(key)
    if key == 'w' then
        if player.grounded then
            player:applyLinearImpulse(0,-4000)
        end
    end
end

-- Query in a circle about the collidors in the range
function love.mousepressed(x,y,button)
    if button == 1 then                                    -- Can specify what sort of collidors it can select
        local collidors = world:queryCircleArea(x,y,150,{'Platform','Danger'}) -- Fills up with all collidors into the table
        for i,c in ipairs(collidors) do
            c:destroy()
        end
    end
end

function spawnPlatform(x,y,width,height)
    if width > 0 and height >0 then
        -- Platform -static
        local platform = world:newRectangleCollider(x,y,width,height,{collision_class = 'Platform'})
        platform:setType('static') -- This sets the collidor to be static
        table.insert(platforms,platform)
    end
end

function loadMap()
    gameMap = sti('maps/level1.lua')
    for i,obj in pairs(gameMap.layers['Platforms'].objects) do
        spawnPlatform(obj.x,obj.y,obj.width,obj.height)  
    end
    for i,obj in pairs(gameMap.layers['Enemies'].objects) do
        spawnEnemies(obj.x,obj.y)
    end

end

--==============================================================================================