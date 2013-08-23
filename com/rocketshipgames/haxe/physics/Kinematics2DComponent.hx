package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;


class Kinematics2DComponent
  implements Component
  implements Position2D
{

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

  public var mass:Float;


  //--------------------------------------------------------------------
  public function new(?opts:Dynamic):Void
  {

    x = xvel = xacc = xdrag = xvelMin = xvelMax = 0.0;
    y = yvel = yacc = ydrag = yvelMin = yvelMax = 0.0;

    mass = 1.0;

    init(opts);

    // end Kinematics2DComponent
  }

  public function init(?opts:Dynamic):Void
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

    // end init
  }


  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    containerHandle.claimCapability("position-2d");
    containerHandle.claimCapability("kinematics-2d");
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {

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
