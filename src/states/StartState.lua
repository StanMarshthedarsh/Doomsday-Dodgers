StartState = Class{__includes = BaseState}

function StartState:init()
    SCORE = 0
    TIMESURVIVED = 0
    self.background = gTextures['background']
    self.street = gTextures['street']
    self.highlighted = 1
    self.entities = {}
    PLAYSTATE = false
    STARTSTATE = true
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 100)
    self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	self.psystem:setEmissionRate(100)
	self.psystem:setSizeVariation(1)
	self.psystem:setLinearAcceleration(-10, 0, 10, -50) -- Random movement in all directions.
	self.psystem:setColors(1, 50 / 255, 0, 0.2, 1, 0, 0, 0) -- Fade to transparency.
end

function StartState:update(dt)
    self.psystem:update(dt)
    gSounds['intro']:setLooping(true)
    gSounds['intro']:setVolume(2)
    gSounds['intro']:play()
    
    if math.random(10) == 5 then
        table.insert(self.entities, FallingEntity(gTextures['asteroid']))
    end
   
    if gSounds['explosion']:isPlaying() then
        gSounds['explosion']:stop()
    end

    gSounds['falling']:setVolume(0.1)
    
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
    if love.keyboard.wasPressed('up') then
        gSounds['select']:play()
        if self.highlighted > 2 then
            self.highlighted = self.highlighted - 2
        elseif self.highlighted == 2 then
            self.highlighted = 6
        else
            self.highlighted = 5
        end
    elseif love.keyboard.wasPressed('down') then
        gSounds['select']:play()
         if self.highlighted < 5 then
            self.highlighted = self.highlighted + 2
        elseif self.highlighted == 5 then
            self.highlighted = 1
        else
            self.highlighted = 2
        end
    elseif love.keyboard.wasPressed('left') then
        gSounds['select']:play()
         if self.highlighted > 1 then
            self.highlighted = self.highlighted - 1
        end
    elseif love.keyboard.wasPressed('right') then
        gSounds['select']:play()
         if self.highlighted < 6 then
            self.highlighted = self.highlighted + 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['select2']:play()
        if self.highlighted == 1 then
            MODE = 'CHILL'
            LIFE = 450
            gStateMachine:change('getready', {
            })
        elseif self.highlighted == 2 then
            MODE = 'EASY'
            LIFE = 450
            gStateMachine:change('getready', {
            })
        elseif self.highlighted == 3 then
            MODE = 'NORMAL'
            LIFE = 1
            gStateMachine:change('getready', {
            })
        elseif self.highlighted == 4 then
            MODE = 'HARD'
            LIFE = 1
            gStateMachine:change('getready', {
            })
        elseif self.highlighted == 5 then
            gSounds['intro']:pause()
            SHOWING = true
        elseif self.highlighted == 6 then
            love.event.quit()
        end
    end
end

function StartState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.street, 0, self.background:getHeight() - 30)
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf("Doomsday Dodgers", 0, VIRTUAL_HEIGHT / 2 - 250, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['large2'])
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', 220, VIRTUAL_HEIGHT / 2 - 100, 350, 100) -- x, y, wrap, align
    love.graphics.printf('Chill Mode', 100, VIRTUAL_HEIGHT / 2 - 75, VIRTUAL_WIDTH / 2 - 50, 'center')
    love.graphics.rectangle('line', 685, VIRTUAL_HEIGHT / 2 - 100, 350, 100)
    love.graphics.printf('Easy Mode', VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 2 - 75, VIRTUAL_WIDTH / 2 + 200, 'center')
    love.graphics.rectangle('line', 220, VIRTUAL_HEIGHT / 2 + 20, 350, 100)
    love.graphics.printf('Normal Mode', 100, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH / 2 - 50, 'center')
   
    love.graphics.printf('Quit', VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 2 + 175, VIRTUAL_WIDTH / 2 + 200, 'center')
    love.graphics.rectangle('line', 685, VIRTUAL_HEIGHT / 2 + 140, 350, 100)
    love.graphics.printf('Hard Mode', VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH / 2 + 200, 'center')
    love.graphics.rectangle('line', 685, VIRTUAL_HEIGHT / 2 + 20, 350, 100)
    
    love.graphics.setColor(1, 0, 0, 100 / 255)
    
    if self.highlighted % 2 == 0 then
        love.graphics.rectangle('fill', 685, VIRTUAL_HEIGHT / 2 - (100 - (120 * (self.highlighted / 2 - 1))), 350, 100)
    else
        if self.highlighted == 1 then
            love.graphics.rectangle('fill', 220, VIRTUAL_HEIGHT / 2 - 100, 350, 100)
        elseif self.highlighted == 3 then
            love.graphics.rectangle('fill', 220, VIRTUAL_HEIGHT / 2 + 20, 350, 100)
        elseif self.highlighted == 5 then
            love.graphics.rectangle('fill', 220, VIRTUAL_HEIGHT / 2 + 140, 350, 100)
        end
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.psystem, love.mouse.getX(), love.mouse.getY())
    for k, entity in pairs(self.entities) do
        entity:render(entity.entitytype)
    end
end
