local namefont = {font = love.graphics.newFont("mnc.ttf", 24), color = {1, 1, 1}} -- font of the name under the box (you know what im talking about)
local hpfont = {font = love.graphics.newFont("hp.ttf", 10), color = {1, 1, 1}}
local player = {x = 320, y = 240, image = love.graphics.newImage("playersoul.png"), name = ("chara"), lv = ("19"), hp = (1), mhp = (92), kr = (1)} -- this is the player
local targetFPS, targetx, targetexpression, targettorsoexpress, targetlegsexpress, targetsweat = 30, 320, "wince", "idle", "idle", "2" -- some things got mixed in here, but its the fps and enemy expression stuff
local frame = {x = 33, y = 250, width = 575, height = 140, thickness = 5} -- this is the box

function love.load()
    love.window.setMode(640, 480) -- size of game window
    love.window.setTitle("ulengine") -- title of the window
    love.graphics.setDefaultFilter("nearest", "nearest") -- to make sure the pixilart doesnt blur
end

function love.update(dt)

    -- the fullscreen toggle, if you can figure out a way to make a better one. please do
    function love.keypressed(key, scancode, isrepeat)
        if key == "f4" then
            fullscreen = not fullscreen
            love.window.setFullscreen(fullscreen, "exclusive")
        end
    end

    player.hp = 46 + 46 * math.sin(love.timer.getTime() * 2)

    -- fps controller
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
    
    -- buttons
    love.graphics.draw(love.graphics.newImage("1false.png"), 33, 431)
    love.graphics.draw(love.graphics.newImage("0false.png"), 187, 431)
    love.graphics.draw(love.graphics.newImage("2false.png"), 345, 431)
    love.graphics.draw(love.graphics.newImage("3false.png"), 499, 431)
    
    -- name
    love.graphics.setColor(namefont.color)
    love.graphics.setFont(namefont.font)
    love.graphics.print(player.name, 30, 400)
    love.graphics.print("lv " .. player.lv, 132, 400)
    love.graphics.print(((player.hp < 10) and "0" or "") .. math.floor(player.hp) .. " / " .. player.mhp, 266 + player.mhp * 1.22 + 38 * player.kr, 400)


    -- hp
    love.graphics.setColor(hpfont.color)
    love.graphics.setFont(hpfont.font)
    love.graphics.print("hp", 225, 406)
    if player.kr == 1 then
        love.graphics.print("kr", 264 + player.mhp * 1.22, 406)
    end

    -- hp bar
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 256, 400, player.mhp * 1.22, 20)
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", 256, 400, player.hp * 1.22, 20)
    
    -- enemy
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(love.graphics.newImage("sanslegs" .. targetlegsexpress .. ".png"), targetx - 46, 174, 0, 2, 2)
    love.graphics.draw(love.graphics.newImage("sanstorso" .. targettorsoexpress .. ".png"), targetx - 50 + 1.75 * math.sin(love.timer.getTime() * 2), 128, 0 + 0.03 * math.sin(love.timer.getTime() * 2), 2, 2)
    love.graphics.draw(love.graphics.newImage("sanshead" .. targetexpression .. ".png"), targetx - 30 + 2 * math.sin(love.timer.getTime() * 2), 80 + 3 * math.sin(love.timer.getTime() * 2), 0, 2, 2)
    love.graphics.draw(love.graphics.newImage("sanssweat" .. targetsweat .. ".png"), targetx - 30 + 2 * math.sin(love.timer.getTime() * 2), 80 + 3 * math.sin(love.timer.getTime() * 2), 0, 2, 2)

    -- frame (battle box)
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", frame.x + frame.thickness, frame.y + frame.thickness, frame.width - 2 * frame.thickness, frame.height - 2 * frame.thickness)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", frame.x, frame.y, frame.width, frame.thickness) -- Top
    love.graphics.rectangle("fill", frame.x, frame.y + frame.height - frame.thickness, frame.width, frame.thickness) -- Bottom
    love.graphics.rectangle("fill", frame.x, frame.y + frame.thickness, frame.thickness, frame.height - 2 * frame.thickness) -- Left
    love.graphics.rectangle("fill", frame.x + frame.width - frame.thickness, frame.y + frame.thickness, frame.thickness, frame.height - 2 * frame.thickness) -- Right

    -- soul (player)
    love.graphics.draw(player.image, player.x - 8, player.y - 8)
end
