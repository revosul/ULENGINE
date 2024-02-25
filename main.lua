local player = {x = 320, y = 240, image = love.graphics.newImage("playersoul.png")}
local targetFPS, targetx, targetexpression, targettorsoexpress, targetlegsexpress, targetsweat = 30, 320, "wince", "idle", "idle", "2"
local frame = {x = 35, y = 250, width = 570, height = 130, thickness = 5}

function love.load()
    love.window.setMode(640, 480)
    love.window.setTitle("rlengine")
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)

    local frameTime = 1 / targetFPS
    love.timer.sleep(math.max(0, frameTime - dt))

    -- player movement
    local speedModifier = love.keyboard.isDown("x") and 2 or 1
    local dx, dy = (love.keyboard.isDown("right") and 6 or 0) - (love.keyboard.isDown("left") and 6 or 0), (love.keyboard.isDown("down") and 5 or 0) - (love.keyboard.isDown("up") and 5 or 0)
    player.x, player.y = player.x + dx / speedModifier, player.y + dy / speedModifier

    -- frame collision
    local frameLeft = frame.x
    local frameRight = frame.x + frame.width 
    local frameTop = frame.y
    local frameBottom = frame.y + frame.height
    if player.x < frameLeft + frame.thickness * 2 + 4 then
        player.x = frameLeft + frame.thickness * 2 + 4 
    elseif player.x > frameRight - frame.thickness * 2 + - 4 then
        player.x = frameRight - frame.thickness * 2 + - 4
    end
    if player.y < frameTop + frame.thickness * 2 + 4 then
        player.y = frameTop + frame.thickness * 2 + 4
    elseif player.y > frameBottom - frame.thickness * 2 - 4 then
        player.y = frameBottom - frame.thickness * 2 + - 4
    end
end

function love.draw()
    love.graphics.draw(love.graphics.newImage("sanslegs" .. targetlegsexpress .. ".png"), targetx - 46, 174, 0, 2, 2)
    love.graphics.draw(love.graphics.newImage("sanstorso" .. targettorsoexpress .. ".png"), targetx - 50 + 1.75 * math.sin(love.timer.getTime() * 2), 128, 0 + 0.03 * math.sin(love.timer.getTime() * 2), 2, 2)
    love.graphics.draw(love.graphics.newImage("sanshead" .. targetexpression .. ".png"), targetx - 30 + 2 * math.sin(love.timer.getTime() * 2), 80 + 3 * math.sin(love.timer.getTime() * 2), 0, 2, 2)
    love.graphics.draw(love.graphics.newImage("sanssweat" .. targetsweat .. ".png"), targetx - 30 + 2 * math.sin(love.timer.getTime() * 2), 80 + 3 * math.sin(love.timer.getTime() * 2), 0, 2, 2)

    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", frame.x + frame.thickness, frame.y + frame.thickness, frame.width - 2 * frame.thickness, frame.height - 2 * frame.thickness)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", frame.x, frame.y, frame.width, frame.thickness) -- Top
    love.graphics.rectangle("fill", frame.x, frame.y + frame.height - frame.thickness, frame.width, frame.thickness) -- Bottom
    love.graphics.rectangle("fill", frame.x, frame.y + frame.thickness, frame.thickness, frame.height - 2 * frame.thickness) -- Left
    love.graphics.rectangle("fill", frame.x + frame.width - frame.thickness, frame.y + frame.thickness, frame.thickness, frame.height - 2 * frame.thickness) -- Right

    love.graphics.draw(player.image, player.x - 8, player.y - 8)
end
