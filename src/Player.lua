Player = Class{}

function Player:init(params)

    self.image = params.image
    self.frame = 0
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - (self.image:getHeight() + 35)
    self.width = self.image:getWidth()
    self.dy = 0
    self.gravity = -500
    self.speed = 200

    self.jumpHeight = -300
    self.isJumping = false
    self.ontopofanvil = false
    self.falling = false

    self.invisible = false
    self.invisibletimer = 10
    self.alpha = 1
    self.red = 0
    self.blue = 1

    self.multiply = false
    self.multiplytimer = 10
    self.red2 = 0
    self.blue2 = 1
    
    self.jump = false
    self.jumptimer = 10
    self.red3 = 0
    self.blue3 = 1

    self.slowmo = false
    self.slowmotimer = 10
    self.red4 = 0
    self.blue4 = 1

    self.frenzy = false
    self.frenzytimer = 20
    self.red5 = 0
    self.blue5 = 1

    self.red6 = 0
    self.green6 = 0.5
    self.blue6 = 1

    self.regen = false
    self.regentimer = 10
    self.red7 = 0
    self.blue7 = 1
    self.regentimer2 = 0

end

function Player:update(dt)
    self.frame = self.frame + dt
        if self.frame >= 0.2 then
            self.frame = 0
        end
    if love.keyboard.wasPressed('space') then
        self.isJumping = true
        self.ontopofanvil = false
        if self.jump == true then
            if self.dy == 0 then
                gSounds['boing']:play()
                self.dy = self.jumpHeight * 2
            end
        else
            if self.dy == 0 then
                self.dy = self.jumpHeight
            end
        end
    end

    if self.isJumping == true or self.falling == true then
        self.y = self.y + self.dy * dt
        self.dy = self.dy - self.gravity * dt
    end

    if self.ontopofanvil == false then
        if self.y > VIRTUAL_HEIGHT - (self.image:getHeight() + 35) then
            self.dy = 0
            self.y = VIRTUAL_HEIGHT - (self.image:getHeight() + 35)
            self.isJumping = false
            self.falling = false
        end
    else
        self.isJumping = false
        self.dy = 0
        self.y = 580
        self.x = self.x - streetSpeed * dt
    end

    if love.keyboard.isDown('right') then
        self.x = self.x + self.speed * dt

    elseif love.keyboard.isDown('left') then
        self.x = self.x - self.speed * dt

    end
    
    if self.x < 0 then
        self.x = math.max(0, self.x)
    elseif self.x > VIRTUAL_WIDTH - (self.image:getWidth() + 20) then
        self.x = math.min(self.x, VIRTUAL_WIDTH - (self.image:getWidth() + 20))
    end

    if self.invisible == true then
        self.invisibletimer = self.invisibletimer - dt
        self.alpha = self.alpha - dt
        self.blue = self.blue - (1 / 10) * dt
        self.red = self.red + (1 / 10) * dt
        if self.invisibletimer <= 0 then
            self.invisible = false
            self.blue = 1
            self.red = 0
            self.invisibletimer = 10
        end
        if self.alpha <= 0 then
            self.alpha = 1
        end
    end
    if self.multiply == true then
        self.multiplytimer = self.multiplytimer - dt
        self.blue2 = self.blue2 - (1 / 10) * dt
        self.red2 = self.red2 + (1 / 10) * dt
        if self.multiplytimer <= 0 then
            self.multiply = false
            self.blue2 = 1
            self.red2 = 0
            self.multiplytimer = 10
        end
    end
    if self.jump == true then
        self.jumptimer = self.jumptimer - dt
        self.blue3 = self.blue3 - (1 / 10) * dt
        self.red3 = self.red3 + (1 / 10) * dt
        if self.jumptimer <= 0 then
            self.jump = false
            self.blue3 = 1
            self.red3 = 0
            self.jumptimer = 10
        end
    end
    if self.slowmo == true then
        self.slowmotimer = self.slowmotimer - dt
        self.blue4 = self.blue4 - (1 / 10) * dt
        self.red4 = self.red4 + (1 / 10) * dt
        if self.slowmotimer <= 0 then
            self.slowmo = false
            self.blue4 = 1
            self.red4 = 0
            self.slowmotimer = 10
        end
    end
    if self.frenzy == true then
        self.frenzytimer = self.frenzytimer - dt
        self.blue5 = self.blue5 - (1 / 20) * dt
        self.red5 = self.red5 + (1 / 20) * dt
        if self.frenzytimer <= 0 then
            self.frenzy = false
            gSounds['frenzy']:stop()
            gSounds['music']:play()
            self.blue5 = 1
            self.red5 = 0
            self.frenzytimer = 20
        end
    end
    if self.regen == true then
        self.regentimer = self.regentimer - dt
        self.blue7 = self.blue7 - (1 / 10) * dt
        self.red7 = self.red7 + (1 / 10) * dt
        if LIFE < 450 then
            LIFE = LIFE + (10 * dt)
            self.regentimer2 = self.regentimer2 + dt
            if self.regentimer2 > 1 then
                self.regentimer2 = 0
                gSounds['heal']:play()
            end
        end
        if self.regentimer <= 0 then
            self.regen = false
            self.blue7 = 1
            self.red7 = 0
            self.regentimer = 10
        end
    end
       
end

function Player:render()

    if MODE == 'EASY' or MODE == 'CHILL' then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['large'])
        love.graphics.print("Fzy: ", 10, 10)
        love.graphics.rectangle('line', 130, 10, 250, 40)
        love.graphics.print("Inv: ", 10, 80)
        love.graphics.rectangle('line', 130, 80, 250, 40)
        love.graphics.print("Jmp: ", 10, 150)
        love.graphics.rectangle('line', 130, 150, 250, 40)
        love.graphics.print("Rgn: ", 10, 220)
        love.graphics.rectangle('line', 130, 220, 250, 40)
        love.graphics.print("Slw: ", 10, 290)
        love.graphics.rectangle('line', 130, 290, 250, 40)
        love.graphics.print("x2: ", 20, 360)
        love.graphics.rectangle('line', 130, 360, 250, 40)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['large'])
        love.graphics.print("Fzy: ", 10, 10)
        love.graphics.rectangle('line', 130, 10, 250, 40)
        love.graphics.print("Inv: ", 10, 80)
        love.graphics.rectangle('line', 130, 80, 250, 40)
        love.graphics.print("Jmp: ", 10, 150)
        love.graphics.rectangle('line', 130, 150, 250, 40)
        love.graphics.print("Slw: ", 10, 220)
        love.graphics.rectangle('line', 130, 220, 250, 40)
        love.graphics.print("x2: ", 20, 290)
        love.graphics.rectangle('line', 130, 290, 250, 40)
        love.graphics.setColor(1, 1, 1, 1)
    end

    if self.invisible == true then
        love.graphics.setColor(1, 1, 1, self.alpha)
        if self.frame < 0.1 and not self.isJumping then
            love.graphics.draw(self.image, self.x, self.y, 0, 1.5, 1.5)
        else
            love.graphics.draw(self.image, self.x + 5, self.y, 0, 1.5, 1.5)
        end
        love.graphics.setColor(1, 1, 1, 1)
    
    elseif self.frenzy == true then
        love.graphics.setColor(math.random(), math.random(), math.random(), 1)
        if self.frame < 0.1 and not self.isJumping then
            love.graphics.draw(self.image, self.x, self.y, 0, 1.5, 1.5)
        else
            love.graphics.draw(self.image, self.x + 5, self.y, 0, 1.5, 1.5)
        end
        love.graphics.setColor(1, 1, 1, 1)
    else
        if self.frame < 0.1 and not self.isJumping then
            love.graphics.draw(self.image, self.x, self.y, 0, 1.5, 1.5)
        else
            love.graphics.draw(self.image, self.x + 5, self.y, 0, 1.5, 1.5)
        end
    end

    if MODE == 'EASY' or MODE == 'CHILL' then
        if self.frenzy == true then
            love.graphics.setColor(self.red5, 0, self.blue5, 1)
            love.graphics.rectangle('fill', 130, 10, self.frenzytimer * 12.5, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.invisible == true then
            love.graphics.setColor(self.red, 0, self.blue, 1)
            love.graphics.rectangle('fill', 130, 80, self.invisibletimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.jump == true then
            love.graphics.setColor(self.red3, 0, self.blue3, 1)
            love.graphics.rectangle('fill', 130, 150, self.jumptimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.regen == true then
            love.graphics.setColor(self.red7, 0, self.blue7, 1)
            love.graphics.rectangle('fill', 130, 220, self.regentimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end
        
        if self.slowmo == true then
            love.graphics.setColor(self.red4, 0, self.blue4, 1)
            love.graphics.rectangle('fill', 130, 290, self.slowmotimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.multiply == true then
            love.graphics.setColor(self.red2, 0, self.blue2, 1)
            love.graphics.rectangle('fill', 130, 360, self.multiplytimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

    
    
        
        if LIFE >= 100 then
            self.red6 = 0
        else
            self.red6 = 1 - (LIFE / 400)
        end

        if LIFE <= 300 then
            self.blue6 = 0
        else
            self.blue6 = LIFE / 400
        end

        if LIFE >= 200 then
            self.green6 = 1 - (LIFE / 400)
        else
            self.green6 = LIFE / 400
        end

        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('HP: ', 520, 50)
        love.graphics.rectangle('line', 605, 50, 450, 40)
        love.graphics.setColor(self.red6, self.green6, self.blue6, 1)
        love.graphics.rectangle('fill', 605, 50, LIFE, 40)
        love.graphics.setColor(1, 1, 1, 1)

    else
        if self.frenzy == true then
            love.graphics.setColor(self.red5, 0, self.blue5, 1)
            love.graphics.rectangle('fill', 130, 10, self.frenzytimer * 12.5, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.invisible == true then
            love.graphics.setColor(self.red, 0, self.blue, 1)
            love.graphics.rectangle('fill', 130, 80, self.invisibletimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.jump == true then
            love.graphics.setColor(self.red3, 0, self.blue3, 1)
            love.graphics.rectangle('fill', 130, 150, self.jumptimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.multiply == true then
            love.graphics.setColor(self.red2, 0, self.blue2, 1)
            love.graphics.rectangle('fill', 130, 290, self.multiplytimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if self.slowmo == true then
            love.graphics.setColor(self.red4, 0, self.blue4, 1)
            love.graphics.rectangle('fill', 130, 220, self.slowmotimer * 25, 40)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end


function Player:collides(entity)
    if entity.entitytype ~= 'laserbeam' then
        if self.x + self.image:getWidth() >= entity.x and self.x <= entity.x + entity.entitytype:getWidth() then
            if self.y + self.image:getHeight() >= entity.y and self.y <= entity.y + entity.entitytype:getHeight() then
                return true
            end
        end
        return false
    
    elseif entity.entitytype == 'laserbeam' and entity.activated == true then
        if self.x + self.image:getWidth() >= entity.x and self.x <= entity.x + entity.width then
            if self.y + self.image:getHeight() >= entity.y and self.y <= entity.y + entity.height then
                return true
            end
        end
        return false
    end

end
