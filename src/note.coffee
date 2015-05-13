TouchSprite = require './touchSprite'

Note = TouchSprite.extend

  ctor : (texture, @_params, @_timer)->
    @_super texture
    @_listeners = []

  start : ->
    @scheduleUpdate()

  addListener: (name, callback)->
    @_listeners.push
      name: name
      callback: callback

  update : ->
    currentTime = @_timer.get()
    if currentTime >= @_params.timing
      @y = @_params.destY
    else
      @y = @_params.destY + (@_params.timing - currentTime) * @_params.speed

    if currentTime >= @_params.timing + @_params.threshold.good
      @_trigger 'judge', 'bad'
      @unscheduleUpdate()
      cb =-> @removeFromParent on
      seq = cc.sequence(
        cc.fadeOut 0.2
        cc.CallFunc.create cb, this
      )
      @runAction seq

  onTouchBegan : (touch, event)->
    return unless @_super touch, event
    @_judge()
    @unscheduleUpdate()
    spawn = cc.spawn(
      cc.fadeOut 0.2
      cc.scaleBy 0.2, 1.5, 1.5
    )
    cb =-> @removeFromParent on
    seq = cc.sequence(
      spawn
      cc.CallFunc.create cb, this
    )
    @runAction seq

  _judge : ->
    currentTime = @_timer.get()
    diffTime = currentTime - @_params.timing
    great = @_params.threshold.great
    good = @_params.threshold.good
    if -great < diffTime < great
      @_trigger 'judge', 'great'
    else if -good < diffTime < good
      @_trigger 'judge', 'good'
    else
      @_trigger 'judge', 'bad'

  _trigger: (name, data)->
    for listener in @_listeners when listener.name is name
      listener.callback name, data
    return

module.exports = Note
