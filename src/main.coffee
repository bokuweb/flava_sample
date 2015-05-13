res = require('./resource').res
resources = require('./resource').resources

cc.game.onStart = ->
  HelloWorldScene = require './app'
  if not cc.sys.isNative and document.getElementById "cocosLoading"
    document.body.removeChild(document.getElementById "cocosLoading")

  cc.view.enableRetina off
  cc.view.adjustViewPort on
  cc.view.setDesignResolutionSize 800, 450, cc.ResolutionPolicy.SHOW_ALL
  cc.view.resizeWithBrowserSize on
  cc.LoaderScene.preload resources, ->
    cc.director.runScene new HelloWorldScene()
  , this

cc.game.run()
