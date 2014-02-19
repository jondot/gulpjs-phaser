console.log 'hello phaser'

preload = ->
  console.log ':preload'
  game.load.image 'sky', '/assets/images/sky.png'
  game.load.image 'ground', '/assets/images/platform.png'
  game.load.image 'star', '/assets/images/star.png'
  game.load.spritesheet 'dude', '/assets/images/dude.png', 32, 48

platforms = null
player = null
cursors = null
stars = null
scoreText = null
score = 0

create = ->
  console.log ':create'
  game.add.sprite 0, 0, 'sky'
  platforms = game.add.group()
  ground = platforms.create 0, game.world.height - 64, 'ground'
  ground.scale.setTo 2, 2
  ground.body.immovable = true

  ledge = platforms.create 400, 400, 'ground'
  ledge.body.immovable = true

  ledge = platforms.create -150, 250, 'ground'
  ledge.body.immovable = true

  game.add.sprite 0, 0, 'star'

  player = game.add.sprite 32, game.world.height - 150, 'dude'

  player.body.bounce.y = 0.2
  player.body.gravity.y = 6
  player.body.collideWorldBounds = true

  player.animations.add 'left', [0..3], 10, true
  player.animations.add 'right', [5..8], 10, true

  cursors = game.input.keyboard.createCursorKeys()
  stars = game.add.group()
 
  for i in [0..12]
    star = stars.create i * 70, 0, 'star'
    star.body.gravity.y = 6
    star.body.bounce.y = 0.7 + Math.random() * 0.2

  scoreText = game.add.text 16, 16, 'score: 0', font: '32px arial', fill: '#000'


collectStar = (player, star)->
  star.kill()
  score += 10
  scoreText.content = "Score: #{score}"

update = ->
  game.physics.collide player, platforms
  game.physics.collide stars, platforms
  game.physics.overlap player, stars, collectStar, null, this

  player.body.velocity.x = 0

  if cursors.left.isDown
    player.body.velocity.x = -150
    player.animations.play 'left'
  else if cursors.right.isDown
    player.body.velocity.x = 150
    player.animations.play 'right'
  else
    player.animations.stop()
    player.frame = 4

  if cursors.up.isDown && player.body.touching.down
    player.body.velocity.y = -350


game = new Phaser.Game 800, 600, Phaser.AUTO, '', preload: preload, create: create, update: update
