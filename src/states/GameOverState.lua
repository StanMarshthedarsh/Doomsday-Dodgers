GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.background = gTextures['background']
    self.street = gTextures['street']
    self.counter = 0
    PLAYSTATE = false
end


function GameOverState:update(dt)
    
    gSounds['music']:stop()
    gSounds['hardmusic']:stop()

    if self.counter == 0 then
        self.counter = self.counter + 1
    end

    if love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

end

function GameOverState:render()
    
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.street, 0, self.background:getHeight() - 30)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(gFonts['title'])
    if CENSORING == false then
        love.graphics.printf("You Died!", VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 2 - 300, 1000, 'center')
    else
        love.graphics.printf("You Died!", VIRTUAL_WIDTH / 2 - 500, VIRTUAL_HEIGHT / 2 - 300, 1000, 'center')
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.print("Score: " .. tostring(math.floor(SCORE)), VIRTUAL_WIDTH / 2 - 180, VIRTUAL_HEIGHT / 2 - 50)
    love.graphics.print("Time Survived: " .. tostring(math.floor(TIMESURVIVED)) .. ' seconds', VIRTUAL_WIDTH / 2 - 380, VIRTUAL_HEIGHT / 2)
    love.graphics.print("Press enter to play again!", VIRTUAL_WIDTH / 2 - 410, VIRTUAL_HEIGHT / 2 + 50)
    love.graphics.setColor(1, 1, 1, 1)
end