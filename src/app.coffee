res = require('./resource').res

GameLayer = cc.Layer.extend
  sprite : null
  ctor : ->
    @_super()
    @_addBg()
    size = cc.winSize
    helloLabel = new cc.LabelTTF "Hello World", "Arial", 38
    helloLabel.x = size.width / 2
    helloLabel.y = size.height / 2
    @addChild helloLabel, 5

  _addBg : ->
    size = cc.director.getWinSize()
    bg = cc.Sprite.create res.bgImage
    bg.x = size.width / 2
    bg.y = size.height / 2
    @addChild bg, 0
    
GameScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new GameLayer()
    @addChild layer

module.exports = GameScene
