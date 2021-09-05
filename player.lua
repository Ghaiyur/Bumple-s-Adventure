--==============================================================================================
-- Player loads
--==============================================================================================

-- This creates a player based collidor and its props
player = world:newRectangleCollider(360,100,40,100,{collision_class = 'Player'}) -- added the class to the collidor as a table
player:setFixedRotation(true) -- Switches off box rotation
player.speed = 240
player.animation = animations.idle
player.isMoving = false
player.direction = 1 -- 1 means right and -1 means left
player.grounded = true

--==============================================================================================
-- Player Updates
--==============================================================================================

function playerUpdate(dt)
    if player.body then -- Do this block only if player body exists

        -- Check if on platform and grounded for animation
        local collidors = world:queryRectangleArea(player:getX() - 20,player:getY() + 50,40,2,{'Platform'})
        if #collidors > 0  then
            player.grounded = true
        else
            player.grounded = false
        end

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
    if player.grounded then
        if player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end

    -- Update for animations
    player.animation:update(dt)

end

--==============================================================================================
-- Player Draw
--==============================================================================================
function playerDraw()
     -- Get player positions
     if player.body then
        local px,py = player:getPosition()

        player.animation:draw(sprites.playersheet,px,py,nil,0.25 * player.direction,0.25,130,300)
    end
end