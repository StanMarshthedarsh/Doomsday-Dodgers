Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

-- utility
require 'src/constants'
require 'src/StateMachine'

-- game states
require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/GetReadyState'
require 'src/states/GameOverState'



require 'src/Player'
require 'src/FallingEntity'

math.randomseed(os.time())

gSounds = { 
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['countdown'] = love.audio.newSource('sounds/countdown.wav', 'static'),
    ['finish'] = love.audio.newSource('sounds/countdown_finish.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/toughbrick.mp3', 'static'),
    ['splat'] = love.audio.newSource('sounds/splat.mp3', 'static'),
    ['falling'] = love.audio.newSource('sounds/asteroidfall.wav', 'static'),
    ['explosion'] = love.audio.newSource('sounds/explosion.mp3', 'static'),
    ['groan'] = love.audio.newSource('sounds/groan.mp3', 'static'),
    ['alarm'] = love.audio.newSource('sounds/alarm.mp3', 'static'),
    ['gameover'] = love.audio.newSource('sounds/gameover.mp3', 'static'),
    ['gameover2'] = love.audio.newSource('sounds/gameover2.mp3', 'static'),
    ['broken'] = love.audio.newSource('sounds/broken.mp3', 'static'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
    ['boing'] = love.audio.newSource('sounds/boing.mp3', 'static'),
    ['frenzy'] = love.audio.newSource('sounds/tissuepapersavestheday.mp3', 'static'),
    ['frenzy2'] = love.audio.newSource('sounds/frenzy.wav', 'static'),
    ['kick'] = love.audio.newSource('sounds/kick.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['select2'] = love.audio.newSource('sounds/select2.wav', 'static'),
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['appear'] = love.audio.newSource('sounds/QRCODE.wav', 'static'),
    ['intro'] = love.audio.newSource('sounds/intro.wav', 'static'),
    ['hardmusic'] = love.audio.newSource('sounds/hardmusic.mp3', 'static')
}

gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['street'] = love.graphics.newImage('graphics/street.png'),
    ['kenny'] = love.graphics.newImage('graphics/kenny.png'),
    ['anvil'] = love.graphics.newImage('graphics/anvil.png'),
    ['virus'] = love.graphics.newImage('graphics/virus.png'),
    ['asteroid'] = love.graphics.newImage('graphics/asteroid.png'),
    ['zombie'] = love.graphics.newImage('graphics/zombie.png'),
    ['invisibility'] = love.graphics.newImage('graphics/invisibility.png'),
    ['2x'] = love.graphics.newImage('graphics/double.png'),
    ['jump'] = love.graphics.newImage('graphics/jump.png'),
    ['slowmo'] = love.graphics.newImage('graphics/snail.png'),
    ['frenzy'] = love.graphics.newImage('graphics/toiletpaper.png'),
    ['regen'] = love.graphics.newImage('graphics/regen.png'),
    ['particle'] = love.graphics.newImage('graphics/fire.jpg')
}

gFrames = {
    
}


gFonts = {
    ['small'] = love.graphics.newFont('fonts/CracklingFire.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/CracklingFire.ttf', 16),
    ['notice'] = love.graphics.newFont('fonts/CracklingFire.ttf', 32),
    ['large'] = love.graphics.newFont('fonts/southpark.ttf', 48),
    ['large2'] = love.graphics.newFont('fonts/CracklingFire.ttf', 48),
    ['title'] = love.graphics.newFont('fonts/CracklingFire.ttf', 96),
    ['countdown'] = love.graphics.newFont('fonts/southpark.ttf', 160)
}