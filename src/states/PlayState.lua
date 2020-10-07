PlayState = Class{__includes = BaseState}

function PlayState:init()
   
   self.background = gTextures['background']
   self.street = gTextures['street']
   self.orientation = 'right'
   self.paused = false

   backgroundScroll = 60
   backgroundSpeed = 60
   streetScroll = 60
   streetSpeed = 120
   
   PLAYSTATE = true
   STARTSTATE = false

   timers = 0

   start = true
  

   self.player = Player({
       image = gTextures['kenny']
   })
   
   self.images = {}
   
   self.score = 0
   self.scoremultiplier = 0
   
   self.timed = false
   self.slowed = 1
   
   if MODE ~= 'HARD' then
        gSounds['music']:play()
        gSounds['music']:setLooping(true)
   else
        gSounds['hardmusic']:play()
        gSounds['hardmusic']:setLooping(true)
   end

   self.entities = {}
   zombiecount = 0
   self.timesurvived = 0
   
end

function PlayState:enter(params)

end

function PlayState:update(dt)
    gSounds['falling']:setVolume(1)
    if love.keyboard.wasPressed('p') then
        if self.paused == false then
            self.paused = true
            if MODE ~= 'HARD' then
                gSounds['music']:pause()
            else
                gSounds['hardmusic']:pause()
            end
        else
            self.paused = false
            if MODE ~= 'HARD' then
                gSounds['music']:play()
            else
                gSounds['hardmusic']:play()
            end
        end
    end

    if self.paused == false then
        self.timesurvived = self.timesurvived + dt
        if self.player.multiply == true then 
            if MODE == "EASY" then
                self.scoremultiplier = 50
            elseif MODE == 'NORMAL' or MODE == 'CHILL' then
                self.scoremultiplier = 100
            else
                self.scoremultiplier = 200
            end
        else
            self.scoremultiplier = 0
        end
        
        if MODE == 'EASY' then
            self.score = self.score + (50 + self.scoremultiplier) * dt
        elseif MODE == 'NORMAL' or MODE == 'CHILL' then
            self.score = self.score + (100 + self.scoremultiplier) * dt
        elseif MODE == 'HARD' then
            self.score = self.score + (200 + self.scoremultiplier) * dt
        end

        
    
        timers = timers + dt
        backgroundScroll = (backgroundScroll + backgroundSpeed * dt)
        streetScroll = (streetScroll + streetSpeed * dt)
        
        self.player:update(dt)
     
        if timers >= 3 or start == true then
            table.insert(self.images, self.background)
            timers = 0
            start = false
        end
        
        if MODE ~= 'CHILL' then
            if math.random(2000) == 50 then -- 2000
                table.insert(self.entities, FallingEntity(gTextures['invisibility']))
            end

            if math.random(1000) == 69 then -- 1000
                table.insert(self.entities, FallingEntity(gTextures['2x']))
            end

            if math.random(1000) == 50 then -- 1500
                table.insert(self.entities, FallingEntity(gTextures['jump']))
            end
            
            if math.random(1500) == 111 then
                table.insert(self.entities, FallingEntity(gTextures['slowmo']))
            end
            
            if math.random(10000) == 6969 then -- math.random(10000) == 6969 
                table.insert(self.entities, FallingEntity(gTextures['frenzy']))
            end
        else
            if math.random(200) == 50 then -- 2000
                table.insert(self.entities, FallingEntity(gTextures['invisibility']))
            end

            if math.random(100) == 69 then -- 1000
                table.insert(self.entities, FallingEntity(gTextures['2x']))
            end

            if math.random(100) == 50 then -- 1500
                table.insert(self.entities, FallingEntity(gTextures['jump']))
            end
            
            if math.random(150) == 111 then
                table.insert(self.entities, FallingEntity(gTextures['slowmo']))
            end
            
            if math.random(250) == 120 then -- math.random(10000) == 6969 
                table.insert(self.entities, FallingEntity(gTextures['frenzy']))
            end
        end
        
        if MODE ~= 'HARD' then
            if math.random(100) == 1 and self.score > 0 then
                table.insert(self.entities, FallingEntity(gTextures['anvil']))
            end
            
            if math.random(100) == 2 and self.score > 2500 then
                table.insert(self.entities, FallingEntity(gTextures['virus']))
            end
            
            if math.random(50) == 1 and self.score > 5000 and zombiecount < 5 then
                zombiecount = zombiecount + 1
                table.insert(self.entities, FallingEntity(gTextures['zombie']))
            end

            if math.random(250) == 5 and self.score > 7500 then
                table.insert(self.entities, FallingEntity(gTextures['asteroid']))
            end

            if math.random(250) == 69 and self.score > 10000 then
                table.insert(self.entities, FallingEntity('laserbeam'))
            end

        else
            if math.random(85) == 1 then
                table.insert(self.entities, FallingEntity(gTextures['anvil']))
            end
            
            if math.random(100) == 2 then
                table.insert(self.entities, FallingEntity(gTextures['virus']))
            end
            
            if math.random(40) == 1 and zombiecount < 10 then
                zombiecount = zombiecount + 1
                table.insert(self.entities, FallingEntity(gTextures['zombie']))
            end

            if math.random(200) == 5 then
                table.insert(self.entities, FallingEntity(gTextures['asteroid']))
            end

            if math.random(100) == 25 then
                table.insert(self.entities, FallingEntity('laserbeam'))
            end
        end

        if MODE == 'EASY' then
            if math.random(3000) == 333 then
                table.insert(self.entities, FallingEntity(gTextures['regen']))
            end
        elseif MODE == 'CHILL' then
            if math.random(100) == 77 then
                table.insert(self.entities, FallingEntity(gTextures['regen']))
            end
        end

       


        for k, entity in pairs(self.entities) do
            entity:update(dt)
            if entity.entitytype == gTextures['zombie'] and self.player.invisible == false then
                if entity.x < self.player.x then
                    entity.x = entity.x + (MOVEMENT_SPEED / (4 * self.slowed)) * dt
                    self.orientation = 'right'
                elseif entity.x > self.player.x then
                    entity.x = entity.x - (MOVEMENT_SPEED / (4 * self.slowed)) * dt
                    self.orientation = 'left'
                else
                    entity.x = entity.x
                    self.orientation = 'right'
                end
            elseif entity.entitytype == gTextures['zombie'] and self.player.invisible == true then
                entity.x = entity.x
                self.orientation = 'right'
            end
            
           
            if self.player.invisible == false and self.player.frenzy == false then
                self.player.speed = 200     
                if self.player:collides(entity) and entity.entitytype ~= gTextures['zombie'] and entity.entitytype ~= gTextures['anvil'] and entity.entitytype ~= gTextures['invisibility'] and entity.entitytype ~= gTextures['2x'] and entity.entitytype ~= gTextures['jump'] and entity.entitytype ~= gTextures['slowmo'] and entity.entitytype ~= gTextures['frenzy'] and entity.entitytype ~= gTextures['regen'] then
                    if entity.entitytype == gTextures['virus'] then
                        gSounds['splat']:play()
                        LIFE = LIFE - 3
                    elseif entity.entitytype == gTextures['asteroid'] then
                        gSounds['explosion']:play()
                        LIFE = LIFE - 12
                    elseif entity.entitytype == 'laserbeam' then
                        gSounds['explosion']:play()
                        LIFE = LIFE - 12
                    end

                    if MODE == 'EASY' or MODE == 'CHILL' then
                        if LIFE < 0 then
                            SCORE = self.score
                            TIMESURVIVED = self.timesurvived
                            gStateMachine:change('game-over', {
                            })
                        end
                    else
                        SCORE = self.score
                        TIMESURVIVED = self.timesurvived
                        gStateMachine:change('game-over', {
                        })
                    end

                elseif entity.entitytype == gTextures['zombie'] and self.player:collides(entity) then
                    if self.player.dy > 0 then
                        entity.y = -100000
                        zombiecount = zombiecount - 1
                        gSounds['splat']:play()
                        self.score = self.score + 200
                    else
                        LIFE = LIFE - 6
                        if MODE == 'EASY' or MODE == 'CHILL' then
                            if LIFE < 0 then
                                SCORE = self.score
                                TIMESURVIVED = self.timesurvived
                                gStateMachine:change('game-over', {
                                })
                            end
                        else
                            SCORE = self.score
                            TIMESURVIVED = self.timesurvived
                            gStateMachine:change('game-over', {
                            })
                        end
                    
                    end

                elseif entity.entitytype == gTextures['anvil'] and self.player:collides(entity) then
                    entity.collided = true
                    if self.player.dy >= 0 and self.player.dx == 0 and self.player.y ~= VIRTUAL_HEIGHT - (self.player.image:getHeight() + 35) then
                        self.player.x = self.player.x - streetSpeed * dt
                        self.player.ontopofanvil = true
                    elseif self.player.dy >= 0 and self.player.dx ~= 0 and self.player.y ~= VIRTUAL_HEIGHT - (self.player.image:getHeight() + 35) then
                        self.player.x = self.player.x 
                        self.player.ontopofanvil = true
                    elseif self.player.ontopofanvil == false then
                        LIFE = LIFE - 6
                        if MODE == 'EASY' or MODE == 'CHILL' then
                            if LIFE < 0 then
                                SCORE = self.score
                                TIMESURVIVED = self.timesurvived
                                gStateMachine:change('game-over', {
                                })
                            end
                        else
                            SCORE = self.score
                            TIMESURVIVED = self.timesurvived
                            gStateMachine:change('game-over', {
                            })
                        end   
                    end
                
                elseif entity.entitytype == gTextures['anvil'] and entity.collided == true then
                    if self.player.x + self.player.width > entity.x + entity.width or self.player.x + self.player.width < entity.x then
                        entity.collided = false
                        self.player.ontopofanvil = false
                        self.player.falling = true
                    end
                elseif self.player:collides(entity) and entity.entitytype == gTextures['invisibility'] then
                    gSounds['powerup']:play()
                    self.player.invisible = true
                    self.player.invisibletimer = 10
                    self.player.blue = 1
                    self.player.red = 0
                    entity.y = -100000
                elseif self.player:collides(entity) and entity.entitytype == gTextures['2x'] then
                    gSounds['powerup']:play()
                    self.player.multiply = true
                    self.player.multiplytimer = 10
                    self.player.blue2 = 1
                    self.player.red2 = 0
                    entity.y = -100000
                elseif self.player:collides(entity) and entity.entitytype == gTextures['jump'] then
                    gSounds['powerup']:play()
                    self.player.jump = true
                    self.player.jumptimer = 10 
                    self.player.blue3 = 1
                    self.player.red3 = 0
                    entity.y = -100000
                elseif self.player:collides(entity) and entity.entitytype == gTextures['slowmo'] then
                    gSounds['powerup']:play()
                    self.player.slowmo = true
                    entity.y = -100000
                    self.player.blue4 = 1
                    self.player.red4 = 0
                    self.player.slowmotimer = 10 
                    self.timed = true
                elseif self.player:collides(entity) and entity.entitytype == gTextures['frenzy'] then
                    gSounds['powerup']:play()
                    gSounds['music']:pause()
                    gSounds['frenzy']:seek(0, 'seconds')
                    gSounds['frenzy']:play()
                    self.player.frenzy = true
                    entity.y = -100000
                    self.player.blue5 = 1
                    self.player.red5 = 0
                    self.player.frenzytimer = 20 
                elseif self.player:collides(entity) and entity.entitytype == gTextures['regen'] then
                    gSounds['powerup']:play()
                    self.player.regen = true
                    self.player.blue7 = 1
                    self.player.red7 = 0
                    self.player.regentimer = 10 
                    entity.y = -100000
                end

            elseif self.player.invisible == true then
                if entity.entitytype == gTextures['frenzy'] then
                    entity.y = -100000
                end
                self.player.speed = 200 
                if self.player:collides(entity) and entity.entitytype == gTextures['invisibility'] then
                    gSounds['powerup']:play()
                    entity.y = -100000
                    self.player.blue = 1
                    self.player.red = 0
                    self.player.invisibletimer = 10
                elseif self.player:collides(entity) and entity.entitytype == gTextures['2x'] then
                    gSounds['powerup']:play()
                    entity.y = -100000
                    self.player.multiply = true
                    self.player.blue2 = 1
                    self.player.red2 = 0
                    self.player.multiplytimer = 10
                elseif self.player:collides(entity) and entity.entitytype == gTextures['jump'] then
                    gSounds['powerup']:play()
                    entity.y = -100000
                    self.player.jump = true
                    self.player.blue3 = 1
                    self.player.red3 = 0
                    self.player.jumptimer = 10  
                elseif self.player:collides(entity) and entity.entitytype == gTextures['slowmo'] then
                    gSounds['powerup']:play()
                    self.player.slowmo = true
                    entity.y = -100000
                    self.player.blue4 = 1
                    self.player.red4 = 0
                    self.player.slowmotimer = 10 
                    self.timed = true
                elseif self.player:collides(entity) and entity.entitytype == gTextures['frenzy'] then
                    gSounds['powerup']:play()
                    gSounds['music']:pause()
                    gSounds['frenzy']:seek(0, 'seconds')
                    gSounds['frenzy']:play()
                    self.player.frenzy = true
                    entity.y = -100000
                    self.player.blue5 = 1
                    self.player.red5 = 0
                    self.player.frenzytimer = 20 
                elseif self.player:collides(entity) and entity.entitytype == gTextures['regen'] then
                    gSounds['powerup']:play()
                    self.player.regen = true
                    self.player.blue7 = 1
                    self.player.red7 = 0
                    self.player.regentimer = 10 
                    entity.y = -100000
                end
            elseif self.player.frenzy == true then
                if entity.entitytype == gTextures['invisibility'] then
                    entity.y = -100000
                end
                self.player.speed = 400
                if self.player:collides(entity) and entity.entitytype == gTextures['invisibility'] then
                    gSounds['powerup']:play()
                    entity.y = -100000
                    self.player.blue = 1
                    self.player.red = 0
                    self.player.invisibletimer = 10
                elseif self.player:collides(entity) and entity.entitytype == gTextures['2x'] then
                    gSounds['powerup']:play()
                    entity.y = -100000
                    self.player.multiply = true
                    self.player.blue2 = 1
                    self.player.red2 = 0
                    self.player.multiplytimer = 10
                elseif self.player:collides(entity) and entity.entitytype == gTextures['jump'] then
                    gSounds['powerup']:play()
                    entity.y = -100000
                    self.player.jump = true
                    self.player.blue3 = 1
                    self.player.red3 = 0
                    self.player.jumptimer = 10  
                elseif self.player:collides(entity) and entity.entitytype == gTextures['slowmo'] then
                    gSounds['powerup']:play()
                    self.player.slowmo = true
                    entity.y = -100000
                    self.player.blue4 = 1
                    self.player.red4 = 0
                    self.player.slowmotimer = 10 
                    self.timed = true
                elseif self.player:collides(entity) and entity.entitytype == gTextures['frenzy'] then
                    gSounds['powerup']:play()
                    gSounds['music']:pause()
                    gSounds['frenzy']:seek(0, 'seconds')
                    gSounds['frenzy']:play()
                    self.player.frenzy = true
                    entity.y = -100000
                    self.player.blue5 = 1
                    self.player.red5 = 0
                    self.player.frenzytimer = 20 
                elseif self.player:collides(entity) and entity.entitytype == gTextures['regen'] then
                    gSounds['powerup']:play()
                    self.player.regen = true
                    self.player.blue7 = 1
                    self.player.red7 = 0
                    self.player.regentimer = 10 
                    entity.y = -100000
                
                elseif self.player:collides(entity) then
                    gSounds['kick']:play()
                    entity.y = -100000
                    self.score = self.score + 100
                end
            end
        
        end
        if self.player.slowmo == true then  
            self.slowed = 2  
            for k, entity in pairs(self.entities) do
                if entity.entitytype == gTextures['anvil'] then
                    entity.weight = 100
                elseif entity.entitytype == gTextures['virus'] then
                    entity.weight = 25
                elseif entity.entitytype == gTextures['asteroid'] then
                    entity.weight = 400
                elseif entity.entitytype == 'laserbeam' and self.timed == true then
                    entity.timer = 2 
                    self.timed = false
                elseif entity.entitytype ~= gTextures['zombie'] and entity.entitytype ~= 'laserbeam' then
                    entity.weight = 50
                end           
            end
            backgroundSpeed = 30
            streetSpeed = 60
        else
            self.slowed = 1
            backgroundSpeed = 60
            streetSpeed = 120
            for k, entity in pairs(self.entities) do
                if entity.entitytype == gTextures['anvil'] then
                    entity.weight = 200
                elseif entity.entitytype == gTextures['virus'] then
                    entity.weight = 50
                elseif entity.entitytype == gTextures['asteroid'] then
                    entity.weight = 800
                elseif entity.entitytype ~= gTextures['zombie'] and entity.entitytype ~= 'laserbeam' then
                    entity.weight = 100
                end           
            end
        end
    end

    
end

function PlayState:render()
    skip = 0
    for k, v in pairs(self.images) do
        love.graphics.draw(self.background, -backgroundScroll + skip, 0)
        love.graphics.draw(self.street, -streetScroll + skip, self.background:getHeight() - 30)
        skip = skip + self.background:getWidth()
    end
    
    for k, entity in pairs(self.entities) do
        entity:render(entity.entitytype)
    end

   self.player:render()
   love.graphics.setFont(gFonts['large'])
   love.graphics.setColor(1, 1, 1, 1)

    if MODE == 'EASY' or MODE == 'CHILL' then
        love.graphics.printf("Score: " .. tostring(math.floor(self.score)), 520, 100, 1000, 'left')
        love.graphics.printf("Time Survived: " .. tostring(math.floor(self.timesurvived)) .. ' seconds', 520, 150, 1000, 'left')
    else
        love.graphics.printf("Score: " .. tostring(math.floor(self.score)), 200, 50, 1000, 'right')
        love.graphics.printf("Time Survived: " .. tostring(math.floor(self.timesurvived)) .. ' seconds', 200, 100, 1000, 'right')
    end
   
   
   love.graphics.setColor(1, 1, 1, 1)
  
    if self.paused == true then
       love.graphics.setFont(gFonts['title'])
       love.graphics.setColor(0, 0, 1, 1)
       love.graphics.print("Game Paused!", VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 2 - 100)
       love.graphics.setColor(1, 1, 1, 1)
    end

   
end
