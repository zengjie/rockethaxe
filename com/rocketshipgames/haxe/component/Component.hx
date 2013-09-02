package com.rocketshipgames.haxe.component;


interface Component
{

  function attach(container:ComponentHandle):Void;
  function detach():Void;

  function activate(?opts:Dynamic):Void;
  function deactivate():Void;

  function update(elapsed:Int):Void;

  // end Component
}
