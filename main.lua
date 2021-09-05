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
    world = wf.newWorld(0,800) -- Gravity of the physics, zero gravity , direction of gravity
    
    -- This creates a player based collidor and its props
    player = world:newRectangleCollider(360,100,80,80)
    player.speed = 240

    -- Platform -static
    platform = world:newRectangleCollider(250,400,300,100)
    platform:setType('static') -- This sets the collidor to be static
end

--==============================================================================================
-- UPDATE
--==============================================================================================

function love.update(dt)
    world:update(dt)

    -- Creates player pos
    local px,py = player:getPosition()
    -- Player movement
    if love.keyboard.isDown('d') then
        player:setX(px+player.speed*dt)
    end
    if love.keyboard.isDown('a') then
        player:setX(px-player.speed*dt)
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
        player:applyLinearImpulse(0,-7000)
    end
    
end