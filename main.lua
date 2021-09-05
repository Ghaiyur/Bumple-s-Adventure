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

    -- Font size
    gameFont = love.graphics.newFont(40)

    -- Import Anim8
    anim8 = require 'libraries/anim8/anim8'

    --import STI
    sti = require 'libraries/Simple-Tiled-Implementation/sti'

    -- Camera tool
    cameraFile = require 'libraries/hump/camera'

    -- Create Object
    cam = cameraFile()

    -- Sounds
    sounds = {}
    sounds.jump = love.audio.newSource('audio/jump.wav','static')
    sounds.music = love.audio.newSource('audio/music.mp3','stream')
    sounds.music:setLooping(true)
    sounds.music:setVolume(0.4)

    -- Play music from start
    sounds.music:play()


    -- Sprites
    sprites = {}
    sprites.playersheet = love.graphics.newImage('sprites/playerSheet.png')
    sprites.enemysheet = love.graphics.newImage('sprites/enemySheet.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

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

    -- Get seriliazer
    require('libraries/show')

    -- Enemies
    danger = world:newRectangleCollider(-500,800,8000,50,{collision_class='Danger'})
    danger:setType('static')

    -- Platforms
    platforms = {}

    -- Flag pos
    flagX = 0
    flagY = 0

    -- Level info
    saveData = {}
    saveData.currentlevel = 1
    saveData.maxlevel = 2

    -- Load level
    if love.filesystem.getInfo('data.lua') then
        local data = love.filesystem.load('data.lua')
        data()
    end

    loadMap(saveData.currentlevel)
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

        local collidors = world:queryCircleArea(flagX,flagY,10,{'Player'})
        if #collidors > 0 then
            saveData.currentlevel = saveData.currentlevel + 1
            if saveData.currentlevel > saveData.maxlevel then
                saveData.currentlevel = 1
            end
            loadMap(saveData.currentlevel)
        end
    end
end
--==============================================================================================
-- DRAW
--==============================================================================================

function love.draw()
    -- Follow BG with cam
    love.graphics.draw(sprites.background,0,0)
    love.graphics.setFont(gameFont)
    love.graphics.printf('Level: ' .. currentlevel,0,250,love.graphics.getWidth(),'center')
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
        -- world:draw()
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
            sounds.jump:play()
        end
    end
    if key == 'r' then -- level change on r click 
        loadMap('level2')
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

-- Destroy all
function destroyAll()
    -- Destory all platforms
    local i = #platforms
    while i > -1 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms,i)
        i = i-1
    end

    -- Destory all enemies
    local i = #enemies
    while i > -1 do
        if enemies[i] ~= nil then
            enemies[i]:destroy()
        end
        table.remove(enemies,i)
        i = i-1
    end
    
end

function loadMap(mapName)
    currentlevel = mapName
    love.filesystem.write('data.lua',table.show(saveData,'saveData'))
    destroyAll()
    gameMap = sti('maps/level' .. mapName .. '.lua')
    -- Create collidor based graphics for Start pos
    for i,obj in pairs(gameMap.layers['Start'].objects) do
        playerstartx = obj.x
        playerstarty = obj.y
    end
    -- Set new respawn pos of the level
    player:setPosition(playerstartx,playerstarty)
    -- Create collidor based graphics for platforms
    for i,obj in pairs(gameMap.layers['Platforms'].objects) do
        spawnPlatform(obj.x,obj.y,obj.width,obj.height)  
    end
    -- Create collidor based graphics for enemies
    for i,obj in pairs(gameMap.layers['Enemies'].objects) do
        spawnEnemies(obj.x,obj.y)
    end
    -- Create collidor based graphics for flag
    for i,obj in pairs(gameMap.layers['Flag'].objects) do
        flagX = obj.x
        flagY = obj.y
    end

end

--==============================================================================================