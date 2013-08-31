package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;


class Position2DComponent
  implements Position2D
  implements Component
{

  public var x:Float;
  public var y:Float;
  public var angle:Float; // Radians


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  private function new():Void
  {
    x = y = angle = 0.0;
    // end new
  }

  // Instantiation through a create() function rather than direct
  // super classing in order for subclass instantiations to not
  // trigger activate() being called twice, i.e., in the parent
  // constructor and again daisy chaining from subclass activate().
  public static function create(?opts:Dynamic):Position2DComponent
  {
    var x = new Position2DComponent();
    x.activate(opts);
    return x;
  }


  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    if (opts == null)
      return;

    var d:Dynamic;

    if ((d = Reflect.field(opts, "x")) != null) {
      x = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "y")) != null) {
      y = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "angle")) != null) {
      angle = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    // end init
  }


  public function deactivate():Void
  {
  }


  //--------------------------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    container.claim(PhysicsCapabilities.CID_POSITION2D);
    // end attach
  }

  public function detach():Void { }


  //------------------------------------------------------------------
  public function update(millis:Int):Void { }

  // end Position2DComponent
}
