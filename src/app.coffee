res      = require('./resource').res
music    = require('./music')
Note     = require('./note')
Timer    = require('./timer')
GameOver = require('./gameOver')

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
    @_score = 0
    @_notesIndex = 0
    @_notes = []
    @_music = cc.audioEngine
    @_timer = new Timer()
    @_addBg()
    @_addDest()
    @_addStartButton()
    @_addScoreLabel()
    @_addJudgeLabel()
    @_addCoverImage()
    @_addTitle()    
    @_preallocateNotes()
    @scheduleUpdate() # こいつを呼ぶとupdateが60FPSで呼ばれる
    @schedule @_timerStartIfMusicPlaying, 0.01
    
  update : ->
    size = cc.director.getWinSize()
    timing = music.note[@_notesIndex]?.timing
    fallTime = (size.height - @_destY) / @_speed
    currentTime = @_timer.get()
    # 落下に要する時間と到達時間から、落下を開始すべき時間であれば落下を開始させる
    if timing - fallTime < currentTime
      @_notes[@_notesIndex++].start()

    if currentTime >= music.playTime
      gameOver = new GameOver()
      @unscheduleUpdate()
      cc.director.runScene new cc.TransitionFade(1.2, gameOver)

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
    if judgement is 'great'
      @_score += 100000 / music.note.length
      @_judgeLabel.setString 'great'
    else if judgement is 'good'
      @_score += 100000 / music.note.length * 0.7
      @_judgeLabel.setString 'good'
    else
      @_judgeLabel.setString 'bad'
    @_scoreLabel.setString ~~(@_score.toFixed())
    @_showJudgeLabel()

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

  _addStartButton : ->
    size = cc.director.getWinSize()
    @_startButton = new cc.LabelTTF "touch here to start", "Arial", 18
    @_startButton.attr
      x : size.width / 2
      y : size.height / 2
    @_startButton.setColor cc.color(0, 0, 0,255)
    seq = cc.sequence cc.fadeTo(1, 0), cc.fadeTo(1, 255)
    @_startButton.runAction new cc.RepeatForever(seq)
    @addChild @_startButton, 15

    eventListener = cc.EventListener.create
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @_onTouchStart.bind @
    cc.eventManager.addListener eventListener, @_startButton

  _onTouchStart : (touch, event) ->
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
      target.removeFromParent on
      @_music.playMusic music.src, false
      true
    false

  _timerStartIfMusicPlaying : ->
    if @_music.isMusicPlaying()
      @_timer.start()
      @unschedule @_timerStartIfMusicPlaying

  _addScoreLabel : ->
    size = cc.director.getWinSize()
    @_scoreLabel = new cc.LabelTTF "0", "Arial", 14, cc.size(100, 0), cc.TEXT_ALIGNMENT_LEFT
    @_scoreLabel.attr
      x : 150
      y : size.height - 100
    @_scoreLabel.setColor cc.color(0, 0, 0, 255)
    @addChild @_scoreLabel, 10

  _addJudgeLabel : ->
    size = cc.director.getWinSize()
    @_judgeLabel = new cc.LabelTTF "", "Arial", 14
    @_judgeLabel.attr
      x : size.width / 2
      y : size.height / 2
      opacity : 0
    @_judgeLabel.setColor cc.color(0, 0, 0, 255)
    @addChild @_judgeLabel, 10

  _showJudgeLabel : ->
    seq = cc.sequence cc.fadeIn(0.2), cc.fadeOut(1)
    @_judgeLabel.runAction seq

  _addCoverImage : ->
    size = cc.director.getWinSize()
    cover = cc.Sprite.create music.coverImage
    cover.x = 50
    cover.y = size.height - 80
    @addChild cover, 5

  _addTitle : ->
    size = cc.director.getWinSize()
    title = new cc.LabelTTF music.title, "Arial", 14, cc.size(100, 0), cc.TEXT_ALIGNMENT_LEFT
    title.attr
      x : 150
      y : size.height - 80
    title.setColor cc.color(0, 0, 0, 255)
    @addChild title, 5

GameScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new GameLayer()
    @addChild layer

module.exports = GameScene
