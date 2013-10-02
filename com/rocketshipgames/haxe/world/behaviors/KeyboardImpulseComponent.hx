package com.rocketshipgames.haxe.world.behaviors;

import com.rocketshipgames.haxe.device.Keyboard;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.core2d.Kinematics2DComponent;

import com.rocketshipgames.haxe.world.ScreenDirection2D;


class KeyboardImpulseComponent
  implements com.rocketshipgames.haxe.component.Component
  implements Facing2D
{

  public var facing:ScreenDirection2D;

  //--------------------------------------------------------------------
  private var kinematics:Kinematics2DComponent;

  private var bindings:KeyboardImpulseBindings;

  private var impulseLeft:Float;
  private var impulseRight:Float;
  private var impulseUp:Float;
  private var impulseDown:Float;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  private function new(?bindings:KeyboardImpulseBindings, ?opts:Dynamic):Void
  {
    if (bindings == null)
      bindings = new DefaultKeyboardImpulseBindings(opts);

    this.bindings = bindings;

    impulseLeft = impulseRight = impulseUp = impulseDown = 83;

    facing = RIGHT;

    // end new
  }

  public static function create(?bindings:KeyboardImpulseBindings,
                                ?opts:Dynamic):KeyboardImpulseComponent
  {
    var x = new KeyboardImpulseComponent(bindings, opts);
    x.activate(opts);
    return x;
  }

  //----------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    container.claim(BehaviorCapabilities.CID_FACING2D);

    kinematics = cast(container.find(PhysicsCapabilities.CID_KINEMATICS2D),
                      Kinematics2DComponent);
  }

  public function detach():Void
  {
  }

  public function activate(?opts:Dynamic):Void
  {
    var d:Dynamic;

    if ((d = Reflect.field(opts, "impulse")) != null) {
      impulseLeft = impulseRight = impulseUp = impulseDown =
        (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "impulseLeft")) != null) {
      impulseLeft = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "impulseRight")) != null) {
      impulseRight = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "impulseUp")) != null) {
      impulseUp = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "impulseDown")) != null) {
      impulseDown = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    // end activate
  }

  public function deactivate():Void
  {
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {

    kinematics.xacc = kinematics.yacc = 0.0;

    if (Keyboard.isKeyDown(bindings.left())) {
      kinematics.xacc = -impulseLeft;
      facing = LEFT;
    } else if (Keyboard.isKeyDown(bindings.right())) {
      kinematics.xacc = impulseRight;
      facing = RIGHT;
    }

    if (Keyboard.isKeyDown(bindings.up())) {
      kinematics.yacc = -impulseUp;
      facing = UP;
    } else if (Keyboard.isKeyDown(bindings.down())) {
      kinematics.yacc = impulseDown;
      facing = DOWN;
    }

    // end update
  }

  // end WalkerKeyboard
}
