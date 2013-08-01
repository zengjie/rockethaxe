package com.rocketshipgames.haxe.ui;

import flash.display.DisplayObjectContainer;

interface Widget {

  function setContainer(container:DisplayObjectContainer):Void;
  function remove():Void;

  function getX():Float;
  function getY():Float;

  function setX(x:Float):Float;
  function setY(y:Float):Float;

  function getWidth():Float;
  function getHeight():Float;

  function show(?opts:Dynamic):Void;
  function hide(?opts:Dynamic):Void;

  // end Widget
}
