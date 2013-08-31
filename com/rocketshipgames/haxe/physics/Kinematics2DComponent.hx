package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;


class Kinematics2DComponent
  implements Component
  implements Position2D
{

  public static var CID:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("kinematics-2d");


  public var x:Float;
  public var y:Float;

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
  public function new(?opts:Dynamic):Void
  {
    x = xvel = xacc = xdrag = xvelMin = 0.0;
    y = yvel = yacc = ydrag = yvelMin = 0.0;
    xvelMax = yvelMax = Math.POSITIVE_INFINITY;

    activate(opts);
    // end Kinematics2DComponent
  }

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


  public function deactivate():Void
  {
  }


  //--------------------------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    container.claim(PhysicsCapabilities.CID_POSITION2D);
    container.claim(CID);
    // end attach
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {
    if (!active)
      return;

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
