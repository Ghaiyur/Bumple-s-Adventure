--==============================================================================================
-- Enemy Load
--==============================================================================================

enemies = {}

--==============================================================================================
-- Misc Functions for Enemy
--==============================================================================================

function spawnEnemies(x,y)
    local enemy = world:newRectangleCollider(x,y,70,90,{collision_class='Danger'})
    enemy.direction = 1
    enemy.speed = 200
    enemy.animation = animations.enemy
    table.insert(enemies,enemy)
end

--==============================================================================================
-- Enemy Update
--==============================================================================================

function enemiesUpdate(dt)
    for i,e in ipairs(enemies) do
        e.animation:update(dt)
        if e.body then
            local ex,ey = e:getPosition()

            -- Query if ground still there
            local collidors = world:queryRectangleArea(ex + (40 * e.direction),ey + 40,10,10,{'Platform'})
            if #collidors == 0 then
                e.direction = e.direction * -1
            end

            e:setX(ex + e.speed * dt * e.direction)
        end
    end
    
end

--==============================================================================================
-- Enemy Draw
--==============================================================================================

function enemiesDraw()
    for i,e in ipairs(enemies) do
        local ex,ey = e:getPosition()
        e.animation:draw(sprites.enemysheet,ex,ey,nil,e.direction,1,50,65)
    end
end