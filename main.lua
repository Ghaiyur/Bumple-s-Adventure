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
    -- Import Windfield
    wf = require 'libraries/windfield/windfield' -- Import
    world = wf.newWorld(0,800,false) -- Gravity of the physics, zero gravity , direction of gravity
    world:setQueryDebugDrawing(true)

    -- Collision Classes
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')
    world:addCollisionClass('Danger')
    

    -- This creates a player based collidor and its props
    player = world:newRectangleCollider(360,100,80,80,{collision_class = 'Player'}) -- added the class to the collidor as a table
    player:setFixedRotation(true) -- Switches off box rotation
    player.speed = 240

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

        -- Creates player pos
        local px,py = player:getPosition()
        -- Player movement
        if love.keyboard.isDown('d') then
            player:setX(px+player.speed*dt)
        end
        if love.keyboard.isDown('a') then
            player:setX(px-player.speed*dt)
        end

        --Death of player with Danger
        if player:enter('Danger') then
            player:destroy()
        end
    end
    
end

--==============================================================================================
-- DRAW
--==============================================================================================

function love.draw()
    world:draw()
    
end

--==============================================================================================
-- MISC FUNCTIONS
    -- -Jump
--==============================================================================================

-- Jump
function love.keypressed(key)
    if key == 'w' then
        local collidors = world:queryRectangleArea(player:getX() -40,player:getY() + 40,80,2,{'Platform'})
        if #collidors > 0 then
            player:applyLinearImpulse(0,-7000)
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
    