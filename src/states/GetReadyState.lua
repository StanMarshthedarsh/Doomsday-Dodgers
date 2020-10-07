GetReadyState = Class{__includes = BaseState}

function GetReadyState:init()
   
   self.background = gTextures['background']
   self.street = gTextures['street']

   self.player = Player({
       image = gTextures['kenny']
   })
   
   self.countdown = 4
   self.counter = 0
   height = -50
   self.timer = 1
   reset = true
   gSounds['intro']:stop()
   gSounds['music']:stop()
   PLAYSTATE = false
   STARTSTATE = false
end


function GetReadyState:update(dt)
    self.countdown = self.countdown - dt
    self.timer = self.timer - dt
    if self.timer > 0.75 and reset == true then
        height = height + 1500 * dt
    elseif self.timer >= 0.25 and self.timer <= 0.75 then
        height = height
    elseif self.timer > 0 and self.timer < 0.25 then
        height = height + 1500 * dt
    else
        self.timer = 1
        reset = false
    end


    if reset == false then
        height = -50
        reset = true
    end
    if self.countdown <= 0.5 then
        gSounds['finish']:play()
        gStateMachine:change('play',{

        })
    elseif self.counter < 2 then
        gSounds['countdown']:play()
        self.counter = self.counter + dt
    end
end

function GetReadyState:render()
    
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.street, 0, self.background:getHeight() - 30)
    self.player:render()
    love.graphics.setFont(gFonts['countdown'])

    if math.floor(self.countdown) == 3 then
        love.graphics.setColor(0, 1, 0, 1)
    elseif math.floor(self.countdown) == 2 then
        love.graphics.setColor(1, 1, 0, 1)
    elseif math.floor(self.countdown) == 1 then
        love.graphics.setColor(1, 0, 0, 1)
    elseif math.floor(self.countdown) == 0 then
        love.graphics.setColor(1, 0, 0, 1)
    end

    if math.floor(self.countdown) ~= 0 then
        love.graphics.print(math.floor(self.countdown), VIRTUAL_WIDTH / 2 - 50, height)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.print("Go!", VIRTUAL_WIDTH / 2 - 150, height)
        love.graphics.setColor(1, 1, 1, 1)
    end

end