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
    
    -- Import Player
    require('player')

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
    playerUpdate(dt)
end
--==============================================================================================
-- DRAW
--==============================================================================================

function love.draw()
    world:draw()
    playerDraw()

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

--==============================================================================================