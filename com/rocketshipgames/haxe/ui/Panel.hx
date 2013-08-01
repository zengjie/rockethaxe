package com.rocketshipgames.haxe.ui;


typedef PanelNotifier = Void->Void;


interface Panel {
  function added(manager:PanelManager, id:String):Void;
  function removed():Void;

  function show(?opts:Dynamic):Void;

  function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void;
  // end Panel
}
