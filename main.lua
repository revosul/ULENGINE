local namefont = {font = love.graphics.newFont("mnc.ttf", 24), colour = {1, 1, 1}} -- font of the name under the box (you know what im talking about)
local hpfont = {font = love.graphics.newFont("hp.ttf", 10), colour = {1, 1, 1}}
local menufont = {font = love.graphics.newFont("DTM-Mono.otf", 26), colour = {1, 1, 1}}
local player = {x = 320, y = 240, image = love.graphics.newImage("playersoul.png"), name = ("chara"), lv = ("19"), hp = (92), mhp = (92), kr = (1), krl = (0), buttonselected = 0} -- this is the player
local targetFPS, targetx, targetexpression, targettorsoexpress, targetlegsexpress, targetsweat, targetname = 60, 320, "mad", "idle", "idle", "2", "Sans" -- some things got mixed in here, but its the fps and enemy expression stuff
local frame = {x = 32, y = 250, width = 577, height = 140, thickness = 5} -- this is the box
local currentscene = 1
local keyDownMenu = {left = false, right = false, z = false, x = false}
local targetWidth = 0
local textTimer = 0  
local textUtils = require("textUtils")
local music
local items = {i1 = "Pie", i2 = "F.Steak", i3 = "I.noodles"}

function love.load()
    love.window.setMode(640, 480) -- size of game window
    love.window.setTitle("luaengine") -- title of the window
    love.graphics.setDefaultFilter("nearest", "nearest") -- to make sure the pixilart doesnt blur

    music = love.audio.newSource("MeGaLoVaNiA.mp3", "stream") -- this is placeholder music
    music:setLooping(true)
    love.audio.play(music)
end

function love.update(dt)

    textTimer = textTimer + dt
    
    if currentscene == 1 and love.keyboard.isDown("z") and not keyDownMenu.z then
        currentscene = currentscene * 10 + player.buttonselected
        keyDownMenu.z = true
    end
    
    if love.keyboard.isDown("2") then
        currentscene = 2
    end

    if love.keyboard.isDown("1") then
        currentscene = 1
    end

    if not love.keyboard.isDown("z") then
        keyDownMenu.z = false
    end

    if not love.keyboard.isDown("x") then
        keyDownMenu.x = false
    end

    -- Limit frame rate to 60 FPS
    love.timer.sleep(1 / targetFPS - dt)

    if currentscene == 1 then

        if love.keyboard.isDown("right") and not keyDownMenu.right then
            player.buttonselected = (player.buttonselected + 1)%4
            keyDownMenu.right = true
        elseif not love.keyboard.isDown("right") then
            keyDownMenu.right = false
        end
    
        if love.keyboard.isDown("left") and not keyDownMenu.left then
            player.buttonselected = (player.buttonselected - 1)%4
            keyDownMenu.left = true
        elseif not love.keyboard.isDown("left") then
            keyDownMenu.left = false
        end

        
        local currentx
        if player.buttonselected == 0 then
            currentx = 33 + 16
        elseif player.buttonselected == 1 then
            currentx = 187 + 16
        elseif player.buttonselected == 2 then
            currentx = 345 + 16
        elseif player.buttonselected == 3 then
            currentx = 499 + 16
        end
        player.x = currentx
        player.y = 452
        
    end

    if currentscene == 10 then
        player.x = 63
        player.y =282

        if love.keyboard.isDown("x") and not keyDownMenu.x then
            currentscene = 1
            keyDownMenu.x = true
        end
        if love.keyboard.isDown("z") and not keyDownMenu.z then
            currentscene = 102
            keyDownMenu.z = true
        end
    end

    if currentscene == 102 then
        player.x = -25
        player.y =282

        if targetWidth ~= 1 then
            targetWidth = math.min(1, targetWidth + dt * (1 - targetWidth) * 4)
        end

        if targetWidth > 1 then 
            targetWidth = 1
        end

        if love.keyboard.isDown("z") and not keyDownMenu.z then
            currentscene = 103
            keyDownMenu.z = true
        end
    end

    if currentscene ~=102 then
        targetWidth = targetWidth - 3 * dt
        if targetWidth < 0 then
            targetWidth = 0
        end
    end

    if currentscene == 11 then
        player.x = 63
        player.y =282

        if love.keyboard.isDown("x") and not keyDownMenu.x then
            currentscene = 1
            keyDownMenu.x = true
        end
        if love.keyboard.isDown("z") and not keyDownMenu.z then
            currentscene = 112
            keyDownMenu.z = true
        end
    end

    if currentscene == 112 then
        player.x = 63
        player.y =282

        if love.keyboard.isDown("x") and not keyDownMenu.x then
            currentscene = 11
            keyDownMenu.x = true
        end
        if love.keyboard.isDown("z") and not keyDownMenu.z then
            currentscene = 113
            keyDownMenu.z = true
        end
    end

    if currentscene == 113 then
        player.x = -25
        player.y =282

        if love.keyboard.isDown("z") and not keyDownMenu.z then
            currentscene = 3
            keyDownMenu.z = true
        end
    end

    if currentscene == 2 then
        -- Player movement
        local speedModifier = love.keyboard.isDown("x") and 2 or 1
        local dx, dy = (love.keyboard.isDown("right") and 200 or 0) - (love.keyboard.isDown("left") and 200 or 0), (love.keyboard.isDown("down") and 200 or 0) - (love.keyboard.isDown("up") and 200 or 0)
        player.x, player.y = player.x + dx / speedModifier * dt, player.y + dy / speedModifier * dt

        -- Frame collision
        local frameLeft = frame.x
        local frameRight = frame.x + frame.width 
        local frameTop = frame.y
        local frameBottom = frame.y + frame.height
        if player.x < frameLeft + frame.thickness * 2 + 4 then
            player.x = frameLeft + frame.thickness * 2 + 4 
        elseif player.x > frameRight - frame.thickness * 2 - 4 then
            player.x = frameRight - frame.thickness * 2 - 4
        end
        if player.y < frameTop + frame.thickness * 2 + 4 then
            player.y = frameTop + frame.thickness * 2 + 4
        elseif player.y > frameBottom - frame.thickness * 2 - 4 then
            player.y = frameBottom - frame.thickness * 2 - 4
        end
    end

    if player.hp > player.mhp then
        player.hp = player.mhp
    end

    if player.krl > 0 and player.kr ~= 1 then
        player.krl = 0
    elseif player.krl > 0 then
        player.krl = player.krl - 2 * dt
    end

    if player.krl + player.hp > player.mhp then
        player.krl = player.mhp - player.hp
    end

    if player.krl < 0 then
        player.krl = 0
    end

end

function love.keypressed(key)
    if key == "z" then
        textTimer = 0
        keyDownMenu.z = false
    elseif key == "f4" then
        local fullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not fullscreen, "exclusive")
    end
end

function love.draw()

    love.graphics.setColor(1, 1, 1)

    -- background
    love.graphics.draw(love.graphics.newImage("background.png"), 15, 15)

    -- buttons
    if currentscene == 2 or currentscene == 113 or currentscene == 102 or currentscene == 103 or currentscene == 3 then
        love.graphics.draw(love.graphics.newImage("0false.png"), 33, 431)
        love.graphics.draw(love.graphics.newImage("1false.png"), 187, 431)
        love.graphics.draw(love.graphics.newImage("2false.png"), 345, 431)
        love.graphics.draw(love.graphics.newImage("3false.png"), 499, 431)
    elseif currentscene ~= 2 then
        love.graphics.draw(love.graphics.newImage("0" .. (player.buttonselected == 0 and "true" or "false") .. ".png"), 33, 431)
        love.graphics.draw(love.graphics.newImage("1" .. (player.buttonselected == 1 and "true" or "false") .. ".png"), 187, 431)
        love.graphics.draw(love.graphics.newImage("2" .. (player.buttonselected == 2 and "true" or "false") .. ".png"), 345, 431)
        love.graphics.draw(love.graphics.newImage("3" .. (player.buttonselected == 3 and "true" or "false") .. ".png"), 499, 431)
    end
    
    -- name
    love.graphics.setColor(namefont.colour)
    love.graphics.setFont(namefont.font)
    love.graphics.print(player.name, 30, 400)
    love.graphics.print("lv " .. player.lv, 132, 400)
    if player.krl + player.hp > player.hp then
        love.graphics.setColor(250, 0, 255)
    end
    love.graphics.print(((player.hp + player.krl < 10) and "0" or "") .. math.floor(player.hp + player.krl) .. " / " .. player.mhp, 266 + player.mhp * 1.22 + 10 + 28 * player.kr, 400)

    -- hp
    love.graphics.setColor(hpfont.colour)
    love.graphics.setFont(hpfont.font)
    love.graphics.print("hp", 225, 406)
    if player.kr == 1 then
        love.graphics.print("kr", 264 + player.mhp * 1.22, 406)
    end

    -- hp bar
    love.graphics.setColor(191, 0, 0)
    love.graphics.rectangle("fill", 256, 400, player.mhp * 1.22, 20)
    love.graphics.setColor(250, 0, 255)
    love.graphics.rectangle("fill", 256 + player.hp * 1.22, 400, player.krl * 1.22, 20)
    love.graphics.setColor(255, 245, 0)
    love.graphics.rectangle("fill", 256, 400, player.hp * 1.22, 20)
    
    -- enemy
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(love.graphics.newImage("sanslegs" .. targetlegsexpress .. ".png"), targetx - 46, 194, 0, 2, 2)
    love.graphics.draw(love.graphics.newImage("sanstorso" .. targettorsoexpress .. ".png"), targetx - 50 + 1.75 * math.sin(love.timer.getTime() * 2), 148, 0 + 0.03 * math.sin(love.timer.getTime() * 2), 2, 2)
    love.graphics.draw(love.graphics.newImage("sanshead" .. targetexpression .. ".png"), targetx - 30 + 2 * math.sin(love.timer.getTime() * 2), 100 + 3 * math.sin(love.timer.getTime() * 2), 0, 2, 2)
    love.graphics.draw(love.graphics.newImage("sanssweat" .. targetsweat .. ".png"), targetx - 30 + 2 * math.sin(love.timer.getTime() * 2), 100 + 3 * math.sin(love.timer.getTime() * 2), 0, 2, 2)

    -- frame (battle box)
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", frame.x + frame.thickness, frame.y + frame.thickness, frame.width - 2 * frame.thickness, frame.height - 2 * frame.thickness)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", frame.x, frame.y, frame.width, frame.thickness) -- Top
    love.graphics.rectangle("fill", frame.x, frame.y + frame.height - frame.thickness, frame.width, frame.thickness) -- Bottom
    love.graphics.rectangle("fill", frame.x, frame.y + frame.thickness, frame.thickness, frame.height - 2 * frame.thickness) -- Left
    love.graphics.rectangle("fill", frame.x + frame.width - frame.thickness, frame.y + frame.thickness, frame.thickness, frame.height - 2 * frame.thickness) -- Right

    local targetsprite = love.graphics.newImage("target.png")
    local desiredWidth = 562 * targetWidth
    local scale = desiredWidth / targetsprite:getWidth()
    local frameCenterX = frame.x + frame.width / 2
    local frameCenterY = frame.y + frame.height / 2
    local spriteWidth = targetsprite:getWidth() * scale
    local spriteHeight = targetsprite:getHeight()
    local spriteX = frameCenterX - spriteWidth / 2
    local spriteY = frameCenterY - spriteHeight / 2
    love.graphics.setColor(1, 1, 1, targetWidth)
    love.graphics.draw(targetsprite, spriteX, spriteY, 0, scale, 1)

    if currentscene == 103 or currentscene == 3 then
        player.x = frameCenterX
        player.y = frameCenterY
    end

    -- menu text
    if currentscene~= 1 and currentscene ~= 113 then
        textTimer = 0
        index = 0
        
    end

    if currentscene == 11 or currentscene == 10 then
        love.graphics.setColor(menufont.colour)
        love.graphics.setFont(menufont.font)
        love.graphics.print("  * " .. targetname, 55, 266)
    end

    if currentscene == 112 then
        love.graphics.setColor(menufont.colour)
        love.graphics.setFont(menufont.font)
        love.graphics.print("  * Check", 55, 266)
    end

    if currentscene == 113 then
        love.graphics.setColor(menufont.colour)
        love.graphics.setFont(menufont.font)
        local text = "*  Sans 1 ATK 1 DEF."
        local speed = 0.05
        local wrapX = 530
        local index = math.floor(textTimer / speed)
        local formattedText = textUtils.typeText(menufont.font, text, speed, index, wrapX)
        love.graphics.print(formattedText, 55, 266)
    elseif currentscene == 1 then
        love.graphics.setColor(menufont.colour)
        love.graphics.setFont(menufont.font)
        local text = "* Your sins weigh heavy on your soul..."
        local speed = 0.05
        local wrapX = 530
        local index = math.floor(textTimer / speed)
        local formattedText = textUtils.typeText(menufont.font, text, speed, index, wrapX)
        love.graphics.print(formattedText, 55, 266)
    end

    -- soul (player)
    love.graphics.setColor(1, 1, 1, 1 - targetWidth)
    love.graphics.draw(player.image, player.x - 8, player.y - 8)

    --fps
    if love.keyboard.isDown("f") then
        love.graphics.setColor(namefont.colour)
        love.graphics.setFont(namefont.font)
        love.graphics.print("FPS: " .. tostring(math.floor(1/love.timer.getDelta())), 3, 0)
    end

end
