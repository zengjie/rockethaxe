package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.SignalDispatcher;


enum BoundsBehavior {
  BOUNDS_NONE;
  BOUNDS_DETECT;
  BOUNDS_STOP;
}

enum BoundsSignalData {
  BOUNDS_LEFT;
  BOUNDS_RIGHT;
  BOUNDS_TOP;
  BOUNDS_BOTTOM;
}


class Bounds2DComponent
  implements Component
{

  public static var CID_BOUNDS2D:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("bounds-2d");

  public static var SIG_BOUNDS2D:
    com.rocketshipgames.haxe.component.SignalID =
    com.rocketshipgames.haxe.component.SignalDispatcher.hashID("bounds");


  //------------------------------------------------------------
  public var boundsCheckType:BoundsBehavior;

  public var left:Float;
  public var top:Float;

  public var right:Float;
  public var bottom:Float;

  public var offBoundsLeft:Void->Void;
  public var offBoundsRight:Void->Void;
  public var offBoundsTop:Void->Void;
  public var offBoundsBottom:Void->Void;

  public var signal:Bool;


  //------------------------------------------------------------
  private var kinematics:Kinematics2DComponent;
  private var dispatcher:SignalDispatcher;

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(?opts:Dynamic):Void
  {

    boundsCheckType = BOUNDS_NONE;
    left = top = right = bottom = 0.0;
    offBoundsLeft = offBoundsRight = offBoundsTop = offBoundsBottom = doNothing;

    signal = false;

    init(opts);

    // end new
  }

  public function init(?opts:Dynamic):Void
  {

    if (opts == null)
      return;

    // end init
  }


  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    containerHandle.claimCapability(CID_BOUNDS2D);

    kinematics =
      cast(containerHandle.findCapability(Kinematics2DComponent.CID_KINEMATICS2D),
           Kinematics2DComponent);

    dispatcher =
      cast(containerHandle.findCapability(SignalDispatcher.CID_SIGNALS),
           SignalDispatcher);

    // end attach
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //------------------------------------------------------------------
  public function setBounds(?type:BoundsBehavior=null,
			    ?left:Float = 0,
			    ?top:Float = 0,
			    ?right:Float = 0,
			    ?bottom:Float = 0):Void
  {
    if (type == null) type = BOUNDS_NONE;

    /*
    if (right == 0 && world != null) right = world.worldWidth;
    if (bottom == 0 && world != null) bottom = world.worldHeight;
    */

    this.left = Math.min(left, right);
    this.right = Math.max(left, right);

    this.top = Math.min(top, bottom);
    this.bottom = Math.max(top, bottom);

    boundsCheckType = type;

    // trace("Bounds set to " + this.left + "," + this.top + "  " +
    //      this.right + "," + this.bottom);

    // end setBounds
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {

    if (boundsCheckType == BOUNDS_NONE)
      return;

    if (kinematics.x < left) {
      if (boundsCheckType == BOUNDS_STOP)
        stopLeft();

      offBoundsLeft();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_LEFT);

      // end x off left
    } else if (kinematics.x > right) {
      if (boundsCheckType == BOUNDS_STOP)
        stopRight();

      offBoundsRight();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_RIGHT);

      // end x off right
    }

    if (kinematics.y < top) {
      if (boundsCheckType == BOUNDS_STOP)
        stopTop();

      offBoundsTop();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_TOP);

      // end y off top
    } else if (kinematics.y > bottom) {
      if (boundsCheckType == BOUNDS_STOP)
        stopBottom();

      offBoundsBottom();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_BOTTOM);

      // end y off bottom
    }

    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function doNothing():Void { }


  //------------------------------------------------------------
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
  public function bounceLeft():Void
  {
    if (kinematics.xvel < 0)
      kinematics.xvel *= -1;
  }
  public function bounceRight():Void
  {
    if (kinematics.xvel > 0)
      kinematics.xvel *= -1;
  }
  public function bounceTop():Void
  {
    if (kinematics.yvel < 0)
      kinematics.yvel *= -1;
  }
  public function bounceBottom():Void
  {
    if (kinematics.yvel > 0)
      kinematics.yvel *= -1;
  }

  // end Bounds2DComponent
}
