FallingEntity = Class{}


function FallingEntity:init(entitytype, laserx)
    
    self.entitytype = entitytype
    
    if self.entitytype == gTextures['anvil'] then
        self.width = self.entitytype:getWidth()
        self.groundhit = false
        self.collided = false
        self.x = math.random(VIRTUAL_WIDTH / 2, VIRTUAL_WIDTH - 64)
        self.y = -100
        self.weight = 200
    elseif self.entitytype == gTextures['virus'] then
        self.groundhit = false
        self.x = math.random(0, VIRTUAL_WIDTH - 64)
        self.y = -20
        self.weight = 50
        self.life = 30
        self.width = self.entitytype:getWidth()
    elseif self.entitytype == gTextures['asteroid'] then
        self.groundhit = false
        self.x = math.random(0, VIRTUAL_WIDTH / 2 + 640)
        self.y = -200
        self.weight = 800
        self.width = self.entitytype:getWidth()
    elseif self.entitytype == gTextures['zombie'] then
        self.groundhit = false
        self.xdeterminer = math.random(1, 2)
        if self.xdeterminer == 1 then
            self.x = -50
        else
            self.x = VIRTUAL_WIDTH + 50
        end
        self.y = VIRTUAL_HEIGHT - (self.entitytype:getHeight() + 30)
        self.weight = 0
        self.width = self.entitytype:getWidth()
    elseif self.entitytype == 'laserbeam' then
        self.groundhit = false
        self.width = 100
        self.height = VIRTUAL_HEIGHT
        self.life = 0.5
        self.timer = 1
        self.x = math.random(0, VIRTUAL_WIDTH - self.width)
        self.y = 0
        self.weight = 0
        self.activated = false
    elseif self.entitytype == gTextures['invisibility'] or self.entitytype == gTextures['2x'] or self.entitytype == gTextures['jump'] or self.entitytype == gTextures['slowmo'] or self.entitytype == gTextures['frenzy'] or self.entitytype == gTextures['regen'] then
        self.groundhit = false
        self.width = self.entitytype:getWidth()
        self.height = self.entitytype:getHeight()
        self.x = math.random(0, VIRTUAL_WIDTH - self.width)
        self.y = -100
        self.weight = 100
        self.alpha = 0
    end

   self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 100)
   self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
   self.psystem:setEmissionRate(100)
   self.psystem:setSizeVariation(1)
   self.psystem:setLinearAcceleration(-100, 0, 100, -200) -- Random movement in all directions.
   self.psystem:setColors(1, 0, 0, 1, 1, 0, 0, 0) -- Fade to transparency.
   self.psystem:setEmitterLifetime(3)

end

function FallingEntity:update(dt, entitytype, x)
    self.psystem:update(dt)
    self.y = self.y + self.weight * dt
    
    if self.entitytype == gTextures['anvil'] then
        if self.y >= VIRTUAL_HEIGHT - self.entitytype:getHeight() then
            if self.groundhit == false then
                self.groundhit = true
                gSounds['hit']:play()
            end
            self.y = math.min(self.y, VIRTUAL_HEIGHT - self.entitytype:getHeight())
            self.x = self.x - streetSpeed * dt
        end
    elseif self.entitytype == gTextures['virus'] then
        self.life = self.life - dt
        if self.y >= VIRTUAL_HEIGHT - (self.entitytype:getHeight() + 20) then
            if self.groundhit == false then
                self.groundhit = true
                gSounds['splat']:play()
            end
            self.y = math.min(self.y, VIRTUAL_HEIGHT - (self.entitytype:getHeight() + 20))
        end
        if self.life <= 0 then
            self.y = -100000
        end
    elseif self.entitytype == gTextures['asteroid'] then
        if self.y >= VIRTUAL_HEIGHT - self.entitytype:getHeight() then
            if self.groundhit == false then
                self.groundhit = true
                gSounds['explosion']:play()
            end
        else
            gSounds['falling']:play()
        end
        if self.groundhit == false then
            self.x = self.x + MOVEMENT_SPEED * dt
        end
    elseif self.entitytype == gTextures['zombie'] then
        gSounds['groan']:play()
    elseif self.entitytype == 'laserbeam' then
        self.timer = self.timer - dt
        if self.life > 0 and self.timer < 0 then
            self.life = self.life - dt
            gSounds['falling']:play()
            gSounds['explosion']:play()
        elseif self.timer < -1 then
            self.timer = 1000000
        elseif self.life < 0 then
            self.y = -100000
        end
    elseif self.entitytype == gTextures['invisibility'] or self.entitytype == gTextures['2x'] or self.entitytype == gTextures['jump'] or self.entitytype == gTextures['slowmo'] or self.entitytype == gTextures['frenzy'] or self.entitytype == gTextures['regen'] then
        self.alpha = self.alpha + dt
        if self.y >= VIRTUAL_HEIGHT - (self.entitytype:getHeight() + 20) then
            if self.groundhit == false then
                self.groundhit = true
                if self.entitytype == gTextures['invisibility'] then
                    gSounds['broken']:play()
                end
            end
            self.y = -100000
        end
        if self.alpha > 1 then
            self.alpha = 0
        end
    end


end

function FallingEntity:render(entitytype, orientation)
    if entitytype == gTextures['asteroid'] then
        love.graphics.draw(entitytype, self.x, self.y, 0, 1, 1)
        if self.groundhit == true and PLAYSTATE == true then
            love.graphics.draw(self.psystem, self.x, VIRTUAL_HEIGHT)
        end
    elseif entitytype == gTextures['zombie'] and orientation == 'right' then
        love.graphics.draw(entitytype, self.x, self.y, 0, 1.5, 1.5)
    elseif entitytype == gTextures['zombie'] and orientation == 'left' then
        love.graphics.draw(entitytype, self.x, self.y, 0, -1.5, 1.5, self.entitytype:getWidth(), 1) 
    elseif entitytype == gTextures['zombie'] then
        love.graphics.draw(entitytype, self.x, self.y, 0, 1.5, 1.5)
    elseif entitytype == gTextures['invisibility'] then
        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.draw(entitytype, self.x, self.y)  
        love.graphics.setColor(1, 1, 1, 1)
    elseif entitytype ~= 'laserbeam' then
        love.graphics.draw(entitytype, self.x, self.y)
    else
        love.graphics.setColor(1, 0, 0, 1)
        if self.timer > 0 and self.timer <= 2 then
            gSounds['alarm']:play()
            love.graphics.rectangle('fill', self.x, self.y, self.width, 100)
            love.graphics.setColor(1, 1, 1, 1)
        else
            self.activated = true
            love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(self.psystem, self.x + self.width / 2, VIRTUAL_HEIGHT)
        end
    end
end