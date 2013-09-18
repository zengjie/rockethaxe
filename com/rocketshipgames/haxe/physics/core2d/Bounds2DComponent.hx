package com.rocketshipgames.haxe.physics.core2d;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.SignalDispatcher;

import com.rocketshipgames.haxe.physics.Extent2D;
import com.rocketshipgames.haxe.physics.Kinematics2D;


class Bounds2DComponent
  implements Component
{

  public static var CID:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("cid_bounds2d");

  public static var SIG_BOUNDS2D:
    com.rocketshipgames.haxe.component.SignalID =
    com.rocketshipgames.haxe.component.SignalDispatcher.hashID("sig_bounds2d");


  public static var BOUNDS_LEFT:Int   = 1;
  public static var BOUNDS_RIGHT:Int  = 2;
  public static var BOUNDS_TOP:Int    = 4;
  public static var BOUNDS_BOTTOM:Int = 8;

  //------------------------------------------------------------
  public var left:Float;
  public var top:Float;

  public var right:Float;
  public var bottom:Float;

  public var response:Int->Void;

  //------------------------------------------------------------
  private var container:ComponentHandle;

  private var kinematics:Kinematics2D;
  private var extent:Extent2D;

  private var dispatcher:SignalDispatcher;
  private var signal:Bool;

  private var active:Bool;

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(?opts:Dynamic):Void
  {
    left = top = right = bottom = 0.0;
    response = doNothing;
    signal = false;
    active = true;
    // end new
  }


  public function enableSignal(enable:Bool=true):Void
  {
    signal = enable;

    if (signal && dispatcher == null && container != null)
      dispatcher = container.signals;

    // end enableSignal
  }

  //--------------------------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    this.container = container;

    container.claim(CID);

    extent =
      cast(container.find(PhysicsCapabilities.CID_EXTENT2D), Extent2D);

    kinematics =
      cast(container.find(PhysicsCapabilities.CID_KINEMATICS2D), Kinematics2D);

    if (signal)
      enableSignal();

    // end attach
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    active = true;
  }

  public function deactivate():Void
  {
    active = false;
  }


  //------------------------------------------------------------------
  public function setBounds(?left:Float = 0,
                            ?top:Float = 0,
                            ?right:Float = 0,
                            ?bottom:Float = 0):Void
  {
    this.left = Math.min(left, right);
    this.right = Math.max(left, right);

    this.top = Math.min(top, bottom);
    this.bottom = Math.max(top, bottom);
    // end setBounds
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {
    if (!active)
      return;

    var hit:Int = 0;

    /*
     * This is done this way, producing a code and then calling the
     * response functions, so that the user function is only called
     * once.  If the response function deletes the object, and
     * therefore its components, and was then called again, it could
     * generate a null pointer error.  This mechanism prevents that
     * for simple, naive response functions, the tradeoff being that
     * the user needs to deconflict the hits if they wanted varied
     * response, i.e., ignoring the top, removing from the bottom, and
     * cycling on the left and right.
     */

    if (extent.left() < left) {
      hit = hit | BOUNDS_LEFT;

    } else if (extent.right() > right) {
      hit = hit | BOUNDS_RIGHT;

    }


    if (extent.top() < top) {
      hit = hit | BOUNDS_TOP;

    } else if (extent.bottom() > bottom) {
      hit = hit | BOUNDS_BOTTOM;

    }


    if (hit != 0) {
      response(hit);

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, hit);
    }

    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function doNothing(hit:Int):Void { }


  //------------------------------------------------------------
  public function cannotLeave(hit:Int):Void
  {

    if (hit & BOUNDS_LEFT != 0)
      cannotLeaveLeft();
    else if (hit & BOUNDS_RIGHT != 0)
      cannotLeaveRight();

    if (hit & BOUNDS_TOP != 0)
      cannotLeaveTop();
    else if (hit & BOUNDS_BOTTOM != 0)
      cannotLeaveBottom();

      // end cannotLeave
  }

  public function cannotLeaveLeft():Void
  {
    if (kinematics.xvel <= 0) {
      kinematics.x = left;
      kinematics.xvel = 0;
    }
  }
  public function cannotLeaveRight():Void
  {
    if (kinematics.xvel >= 0) {
      kinematics.x = right;
      kinematics.xvel = 0;
    }
  }
  public function cannotLeaveTop():Void
  {
    if (kinematics.yvel <= 0) {
      kinematics.y = top;
      kinematics.yvel = 0;
    }
  }
  public function cannotLeaveBottom():Void
  {
    if (kinematics.yvel >= 0) {
      kinematics.y = bottom;
      kinematics.yvel = 0;
    }
  }


  //------------------------------------------------------------
  public function stop(hit:Int):Void
  {

    if (hit & BOUNDS_LEFT != 0)
      stopLeft();
    else if (hit & BOUNDS_RIGHT != 0)
      stopRight();

    if (hit & BOUNDS_TOP != 0)
      stopTop();
    else if (hit & BOUNDS_BOTTOM != 0)
      stopBottom();

    // end stop
  }

  public function stopLeft():Void
  {
    kinematics.x = left;
    kinematics.xvel = 0;
  }
  public function stopRight():Void
  {
    kinematics.x = right;
    kinematics.xvel = 0;
  }
  public function stopTop():Void
  {
    kinematics.y = top;
    kinematics.yvel = 0;
  }
  public function stopBottom():Void
  {
    kinematics.y = bottom;
    kinematics.yvel = 0;
  }


  //------------------------------------------------------------
  public function cycle(hit:Int):Void
  {

    if (hit & BOUNDS_LEFT != 0)
      cycleLeft();
    else if (hit & BOUNDS_RIGHT != 0)
      cycleRight();

    if (hit & BOUNDS_TOP != 0)
      cycleTop();
    else if (hit & BOUNDS_BOTTOM != 0)
      cycleBottom();

    // end cycle
  }

  public function cycleLeft():Void
  {
    kinematics.x = right;
  }
  public function cycleRight():Void
  {
    kinematics.x = left;
  }
  public function cycleTop():Void
  {
    kinematics.y = bottom;
  }
  public function cycleBottom():Void
  {
    kinematics.y = top;
  }


  //------------------------------------------------------------
  public function bounce(hit:Int):Void
  {

    if (hit & BOUNDS_LEFT != 0)
      bounceLeft();
    else if (hit & BOUNDS_RIGHT != 0)
      bounceRight();

    if (hit & BOUNDS_TOP != 0)
      bounceTop();
    else if (hit & BOUNDS_BOTTOM != 0)
      bounceBottom();

    // end bounce
  }

  public function bounceLeft():Void
  {
    if (kinematics.xvel < 0) {
      kinematics.xvel *= -1;
      kinematics.x += (left - extent.left());
    }
  }
  public function bounceRight():Void
  {
    if (kinematics.xvel > 0) {
      kinematics.xvel *= -1;
      kinematics.x += (right - extent.right());
    }
  }
  public function bounceTop():Void
  {
    if (kinematics.yvel < 0) {
      kinematics.yvel *= -1;
      kinematics.y += (top - extent.top());
    }
  }
  public function bounceBottom():Void
  {
    if (kinematics.yvel > 0) {
      kinematics.yvel *= -1;
      kinematics.y += (bottom - extent.bottom());
    }
  }

  // end Bounds2DComponent
}
