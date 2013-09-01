package com.rocketshipgames.haxe.gfx.sprites;

interface SpritesheetRenderer
{

  function attach(container:SpritesheetContainer):Void;

  function render(viewport:com.rocketshipgames.haxe.gfx.Viewport):Void;

  // end SpritesheetRenderer
}
