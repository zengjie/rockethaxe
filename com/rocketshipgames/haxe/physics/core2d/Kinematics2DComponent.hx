package com.rocketshipgames.haxe.physics.core2d;

import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.Kinematics2D;


class Kinematics2DComponent
  extends Position2DComponent
  implements Kinematics2D
{

  public var xvel:Float;
  public var xacc:Float;
  public var xdrag:Float;

  public var yvel:Float;
  public var yacc:Float;
  public var ydrag:Float;

  public var xvelMin:Float;
  public var xvelMax:Float;

  public var yvelMin:Float;
  public var yvelMax:Float;


  //----------------------------------------------------
  private var active:Bool;


  //--------------------------------------------------------------------
  private function new():Void
  {
    super();

    xvel = xacc = xdrag = xvelMin = 0.0;
    yvel = yacc = ydrag = yvelMin = 0.0;
    xvelMax = yvelMax = Math.POSITIVE_INFINITY;

    // end Kinematics2DComponent
  }

  // Instantiation through a create() function rather than direct
  // super classing in order for subclass instantiations to not
  // trigger activate() being called twice, i.e., in the parent
  // constructor and again daisy chaining from subclass activate().
  public static function create(?opts:Dynamic):Kinematics2DComponent
  {
    var x = new Kinematics2DComponent();
    x.activate(opts);
    return x;
  }

  public override function activate(?opts:Dynamic):Void
  {

    super.activate(opts);

    if (opts == null)
      return;

    var d:Dynamic;

    if ((d = Reflect.field(opts, "xvel")) != null) {
      xvel = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "yvel")) != null) {
      yvel = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "xvelMin")) != null) {
      xvelMin = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "yvelMin")) != null) {
      yvelMin = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "xvelMax")) != null) {
      xvelMax = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "yvelMax")) != null) {
      yvelMax = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "xacc")) != null) {
      xacc = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "yacc")) != null) {
      yacc = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "xdrag")) != null) {
      xdrag = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "ydrag")) != null) {
      ydrag = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    active = true;

    // end init
  }


  //--------------------------------------------------------------------
  public override function attach(container:ComponentHandle):Void
  {
    super.attach(container);
    container.claim(PhysicsCapabilities.CID_KINEMATICS2D);
    // end attach
  }


  //------------------------------------------------------------------
  public override function update(millis:Int):Void
  {

    if (!active)
      return;

    //    trace("Millis " + millis);
    if (millis > 45) {
      trace("\n\n******************************************************** BAD  Millis " + millis + "\n\n");
    }

    var elapsed:Float = millis/1000.0;

    //-------
    // x
    if (xacc == 0) {
      if (xvel > 0) {
        xvel -= xdrag * elapsed;
        if (xvel < 0)
          xvel = 0;
      } else {
        xvel += xdrag * elapsed;
        if (xvel > 0)
          xvel = 0;
      }
    } else  {
      xvel += xacc * elapsed;
      if (Math.abs(xvel) < xvelMin) {
        xvel = 0;
      } else if (xvel < -xvelMax)
        xvel = -xvelMax;
      else if (xvel > xvelMax)
        xvel = xvelMax;
    }

    //-------
    // y
    if (yacc == 0) {
      if (yvel > 0) {
        yvel -= ydrag * elapsed;
        if (yvel < 0)
          yvel = 0;
      } else {
        yvel += ydrag * elapsed;
        if (yvel > 0)
          yvel = 0;
      }
    } else {
      yvel += yacc * elapsed;
      if (Math.abs(yvel) < yvelMin)
        yvel = 0;
      else if (yvel < -yvelMax)
        yvel = -yvelMax;
      else if (yvel > yvelMax)
        yvel = yvelMax;
    }

    x += xvel*elapsed;
    y += yvel*elapsed;

    // end update
  }

  // end class Kinematics2DComponent
}
