package com.rocketshipgames.haxe.physics.core2d;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.SignalDispatcher;

import com.rocketshipgames.haxe.physics.Extent2D;
import com.rocketshipgames.haxe.physics.Kinematics2D;


enum Bounds2DSignalData {
  BOUNDS_LEFT;
  BOUNDS_RIGHT;
  BOUNDS_TOP;
  BOUNDS_BOTTOM;
}


class Bounds2DComponent
  implements Component
{

  public static var CID:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("cid_bounds2d");

  public static var SIG_BOUNDS2D:
    com.rocketshipgames.haxe.component.SignalID =
    com.rocketshipgames.haxe.component.SignalDispatcher.hashID("sig_bounds2d");


  //------------------------------------------------------------
  public var left:Float;
  public var top:Float;

  public var right:Float;
  public var bottom:Float;

  public var offBoundsLeft:Void->Void;
  public var offBoundsRight:Void->Void;
  public var offBoundsTop:Void->Void;
  public var offBoundsBottom:Void->Void;


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
    offBoundsLeft = offBoundsRight = offBoundsTop = offBoundsBottom = doNothing;

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


    if (extent.left() < left) {
      offBoundsLeft();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_LEFT);

      // end x off left
    } else if (extent.right() > right) {
      offBoundsRight();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_RIGHT);

      // end x off right
    }

    if (extent.top() < top) {
      offBoundsTop();

      if (signal)
        dispatcher.signal(SIG_BOUNDS2D, BOUNDS_TOP);

      // end y off top
    } else if (extent.bottom() > bottom) {
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
