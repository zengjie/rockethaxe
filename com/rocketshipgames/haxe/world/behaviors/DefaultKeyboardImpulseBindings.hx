package com.rocketshipgames.haxe.world.behaviors;

import com.rocketshipgames.haxe.device.Keyboard;


class DefaultKeyboardImpulseBindings
  implements KeyboardImpulseBindings
{

  public var keyLeft:Int  = Keyboard.LEFT;
  public var keyRight:Int = Keyboard.RIGHT;
  public var keyUp:Int    = Keyboard.UP;
  public var keyDown:Int  = Keyboard.DOWN;

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(?opts:Dynamic):Void
  {
    if (opts == null)
      return;

    var d:Dynamic;

    if ((d = Reflect.field(opts, "left")) != null) {
      keyLeft = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    if ((d = Reflect.field(opts, "right")) != null) {
      keyRight = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    if ((d = Reflect.field(opts, "up")) != null) {
      keyUp = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    if ((d = Reflect.field(opts, "down")) != null) {
      keyDown = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    // end new
  }

  //--------------------------------------------------------------------
  public function left():Int  { return keyLeft; }
  public function right():Int { return keyRight; }
  public function up():Int    { return keyUp; }
  public function down():Int  { return keyDown; }

  // end KeyboardImpulseBindings
}
