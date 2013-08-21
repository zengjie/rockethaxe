package com.rocketshipgames.haxe.component;


interface Component
{

  function attach(containerHandle:ComponentHandle):Void;
  function detach():Void;

  function update(elapsed:Int):Void;

  // end Component
}
