res   = require('./resource').res
music = require('./music')
Note  = require('./note')
Timer = require('./timer')

GameLayer = cc.Layer.extend
  _keyNum : 5
  _margin : 60
  _offset : 38
  _destY  : 60
  _speed  : 600
  _threshold :
    great : 0.2
    good  : 0.4
  ctor : ->
    @_super()
    @_notesIndex = 0
    @_notes = []
    @_timer = new Timer()
    @_addBg()
    @_addDest()
    @_preallocateNotes()
    @scheduleUpdate() # こいつを呼ぶとupdateが60FPSで呼ばれる
    @_timer.start()

  update : ->
    size = cc.director.getWinSize()
    timing = music.note[@_notesIndex]?.timing
    fallTime = (size.height - @_destY) / @_speed
    currentTime = @_timer.get()
    # 落下に要する時間と到達時間から、落下を開始すべき時間であれば落下を開始させる
    if timing - fallTime < currentTime
      @_notes[@_notesIndex++].start()

  _preallocateNotes : ->
    size = cc.director.getWinSize()
    for v in music.note
      params =
        timing    : v.timing
        destY     : @_destY
        speed     : @_speed
        threshold : @_threshold
      note = new Note res.noteImage, params, @_timer
      note.attr
        x : v.key * @_margin + @_offset
        y : size.height + note.height   # 画面外に描画しておく

      @addChild note, 10
      note.addListener 'judge', @_onJudge.bind this
      @_notes.push note  # 配列に入れておく

  _onJudge : (name, judgement)->
    cc.log judgement

  _addBg : ->
    size = cc.director.getWinSize()
    bg = cc.Sprite.create res.bgImage
    bg.x = size.width / 2
    bg.y = size.height / 2
    @addChild bg, 0

  _addDest : ->
    size = cc.director.getWinSize()
    for i in [0...@_keyNum]
      dest = new cc.Sprite res.destImage
      dest.attr
        x: i * @_margin + @_offset
        y: @_destY
      @addChild dest, 5

GameScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new GameLayer()
    @addChild layer

module.exports = GameScene
