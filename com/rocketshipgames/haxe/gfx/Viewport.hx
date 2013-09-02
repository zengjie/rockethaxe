package com.rocketshipgames.haxe.gfx;

import com.rocketshipgames.haxe.device.Display;


class Viewport
{

  public var x:Float;
  public var y:Float;

  public var width:Float;
  public var height:Float;

  //--------------------------------------------------------------------
  public function new():Void
  {
    x = y = 0.0;

    width = Display.width;
    height = Display.height;

    // end new
  }

  // end Viewport
}
