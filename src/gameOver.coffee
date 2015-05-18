res    = require('./resource').res

GameOverLayer = cc.Layer.extend
  ctor : ->
    @_super()
    @_addBg()
    @_addMessage()

  _addBg : ->
    size = cc.director.getWinSize()
    bg = cc.Sprite.create res.bgImage
    bg.x = size.width / 2
    bg.y = size.height / 2
    @addChild bg, 0

  _addMessage : ->
    size = cc.director.getWinSize()
    message = new cc.LabelTTF "Game Over", "Arial", 20
    message.x = size.width / 2
    message.y = size.height / 2
    message.setColor cc.color(0, 0, 0, 255)
    @addChild message, 5

GameOverScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new GameOverLayer()
    @addChild layer

module.exports = GameOverScene
