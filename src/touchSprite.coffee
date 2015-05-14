TouchSprite = cc.Sprite.extend
  ctor : (texture)->
    @_super texture
    eventListener = cc.EventListener.create
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @onTouchBegan.bind this
    cc.eventManager.addListener eventListener, this

  onTouchBegan : (touch, event)->
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
      cc.log "touch began!!"
      true

module.exports = TouchSprite
