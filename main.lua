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

    -- Import Anim8
    anim8 = require 'libraries/anim8/anim8'

    -- Sprites
    sprites = {}
    sprites.playersheet = love.graphics.newImage('sprites/playerSheet.png')

    -- Get grid of the sheet
    local grid = anim8.newGrid(614,564,sprites.playersheet:getWidth(),sprites.playersheet:getHeight())
    
    -- Animations
    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15',1),0.04) -- 1-15 is columns and 1 is the row
    animations.jump = anim8.newAnimation(grid('1-7',2),0.04)
    animations.run = anim8.newAnimation(grid('1-15',3),0.04)

    -- Import Windfield
    wf = require 'libraries/windfield/windfield' -- Import
    world = wf.newWorld(0,800,false) -- Gravity of the physics, zero gravity , direction of gravity
    world:setQueryDebugDrawing(true)

    -- Collision Classes
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')
    world:addCollisionClass('Danger')
    

    -- This creates a player based collidor and its props
    player = world:newRectangleCollider(360,100,40,100,{collision_class = 'Player'}) -- added the class to the collidor as a table
    player:setFixedRotation(true) -- Switches off box rotation
    player.speed = 240
    player.animation = animations.idle
    player.isMoving = false
    player.direction = 1 -- 1 means right and -1 means left

    -- Platform -static
    platform = world:newRectangleCollider(250,400,300,100,{collision_class = 'Platform'})
    platform:setType('static') -- This sets the collidor to be static

    -- Enemies
    danger = world:newRectangleCollider(0,550,800,50,{collision_class='Danger'})
    danger:setType('static')


end

--==============================================================================================
-- UPDATE
    -- - Player movement stuff
--==============================================================================================

function love.update(dt)
    world:update(dt)

    if player.body then -- Do this block only if player body exists
        --Every frame set ismoving to false, but if pressed set to true
        player.isMoving = false

        -- Creates player pos
        local px,py = player:getPosition()
        -- Player movement
        if love.keyboard.isDown('d') then
            player:setX(px+player.speed*dt)
            player.isMoving = true
            player.direction = 1
        end
        if love.keyboard.isDown('a') then
            player:setX(px-player.speed*dt)
            player.isMoving = true
            player.direction = -1
        end

        --Death of player with Danger
        if player:enter('Danger') then
            player:destroy()
        end
    end

    -- Change the animation to running when ismoving is true
    if player.isMoving then
        player.animation = animations.run
    else
        player.animation = animations.idle
    end

    -- Update for animations
    player.animation:update(dt)
    
end

--==============================================================================================
-- DRAW
--==============================================================================================

function love.draw()
    world:draw()

    -- Get player positions
    if player.body then
        local px,py = player:getPosition()

        player.animation:draw(sprites.playersheet,px,py,nil,0.25 * player.direction,0.25,130,300)
    end
end

--==============================================================================================
-- MISC FUNCTIONS
    -- -Jump
--==============================================================================================

-- Jump
function love.keypressed(key)
    if key == 'w' then
        local collidors = world:queryRectangleArea(player:getX() - 20,player:getY() + 50,40,2,{'Platform'})
        if #collidors > 0 then
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
    