HelloWorldLayer = cc.Layer.extend
  sprite : null
  ctor : ->
    @_super()
    size = cc.winSize
    helloLabel = new cc.LabelTTF "Hello World", "Arial", 38
    helloLabel.x = size.width / 2
    helloLabel.y = size.height / 2
    @addChild helloLabel, 5

HelloWorldScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new HelloWorldLayer()
    @addChild layer

module.exports = HelloWorldScene
