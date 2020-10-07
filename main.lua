require 'src/dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(gFonts['medium'])
    love.window.setTitle("Doomsday Dodgers")
    Icon = love.image.newImageData("graphics/asteroid.png")
    love.window.setIcon(Icon)
    math.randomseed(os.time())
    RICKROLL = love.graphics.newImage('src/states/UselessState/ /cmon/theresnothinginhereok/I give up/untitled folder/DARUDE SANDSTORM.png')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['getready'] = function() return GetReadyState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
    }
    
    CENSORING = false
    SHOWING = false
    played = false
    spinmeround = 36
    scaleX = 0
    scaleY = 0

    gStateMachine:change('start')
    
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    
    if key == 'kpenter' then
        if PLAYSTATE == true then
            if MODE ~= 'HARD' then
                gSounds['music']:pause()
            else
                gSounds['hardmusic']:pause()
            end
        else
            gSounds['intro']:pause()
        end
        SHOWING = true
    end
    if key == 'q' then
        SHOWING = false
        if PLAYSTATE == true then
            if MODE ~= 'HARD' then
                gSounds['music']:play()
            else
                gSounds['hardmusic']:play()
            end
        elseif STARTSTATE == true then
            gSounds['intro']:play()
        end
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    if SHOWING == false then
        gStateMachine:update(dt)
        scaleX = 0
        scaleY = 0
        spinmeround = 36
        played = false
    else
        gSounds['music']:pause()
        gSounds['hardmusic']:pause()
        gSounds['frenzy']:pause()
        if spinmeround > 0 then
            spinmeround = spinmeround - (36 * dt)
        end
        if scaleX < 1 and scaleY < 1 then
            scaleX = scaleX + dt
            scaleY = scaleY + dt
        end
        if played == false then
            gSounds['appear']:play()
            played = true
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    if SHOWING == true then
        love.graphics.setBackgroundColor(1, 1, 1, 1)
        love.graphics.draw(RICKROLL, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, spinmeround, scaleX, scaleY, RICKROLL:getWidth() / 2, RICKROLL:getHeight() / 2) -- YOU GOT RICKROLLED!
        love.graphics.print("Press q to go back", 0, 0)
    else
        gStateMachine:render()
    end
    push:finish()
end