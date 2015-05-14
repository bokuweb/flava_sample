res   = require('./resource').res
Note  = require('./note')
Timer = require('./timer')

GameLayer = cc.Layer.extend
  ctor : ->
    @_super()
    @_addBg()
    @_timer = new Timer()
    params =
      timing    : 4
      destY     : 0
      speed     : 500
      threshold :
        great : 0.2
        good  : 0.4

    note = new Note res.noteImage, params, @_timer
    note.attr
      x : 160
      y : 480

    @addChild note, 10
    note.addListener 'judge', @_onJudge.bind this
    note.start()
    @_timer.start()

  _onJudge : (name, judgement)->
    cc.log judgement

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
