package com.rocketshipgames.haxe.physics;

enum BoundsBehavior {
  BOUNDS_NONE;
  BOUNDS_DETECT;
  BOUNDS_STOP;
}


class Kinematics2DComponent
  implements com.rocketshipgames.haxe.component.Component
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


  //----------------------------------------------------
  public var boundsCheckType:BoundsBehavior;

  public var left:Float;
  public var top:Float;

  public var right:Float;
  public var bottom:Float;

  public var offBoundsLeft:Void->Void;
  public var offBoundsRight:Void->Void;
  public var offBoundsTop:Void->Void;
  public var offBoundsBottom:Void->Void;


  //--------------------------------------------------------------------
  public function new(?opts:Dynamic):Void
  {

    x = xvel = xacc = xdrag = xvelMin = xvelMax = 0.0;
    y = yvel = yacc = ydrag = yvelMin = yvelMax = 0.0;

    mass = 1.0;

    boundsCheckType = BOUNDS_NONE;
    left = top = right = bottom = 0.0;
    offBoundsLeft = offBoundsRight = offBoundsTop = offBoundsBottom = null;

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
  public function attach(containerHandle:com.rocketshipgames.haxe.component.ComponentHandle):Void
  {
    containerHandle.claimCapability("physics");
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

    checkBounds();

    // end update
  }

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

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function cannotLeaveLeft():Void
  {
    if (xvel <= 0) {
      x = left;
      xvel = 0;
    }
  }
  public function cannotLeaveRight():Void
  {
    if (xvel >= 0) {
      x = right;
      xvel = 0;
    }
  }
  public function cannotLeaveTop():Void
  {
    if (yvel <= 0) {
      y = top;
      yvel = 0;
    }
  }
  public function cannotLeaveBottom():Void
  {
    if (yvel >= 0) {
      y = bottom;
      yvel = 0;
    }
  }

  //------------------------------------------------------------
  public function stopLeft():Void
  {
    x = left;
    xvel = 0;
  }
  public function stopRight():Void
  {
    x = right;
    xvel = 0;
  }
  public function stopTop():Void
  {
    y = top;
    yvel = 0;
  }
  public function stopBottom():Void
  {
    y = bottom;
    yvel = 0;
  }

  //------------------------------------------------------------
  public function cycleLeft():Void
  {
    x = right;
  }
  public function cycleRight():Void
  {
    x = left;
  }
  public function cycleTop():Void
  {
    y = bottom;
  }
  public function cycleBottom():Void
  {
    y = top;
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function checkBounds():Void
  {

    if (boundsCheckType == BOUNDS_NONE)
      return;

    if (x < left) {
      if (boundsCheckType == BOUNDS_STOP)
        stopLeft();

      if (offBoundsLeft != null)
        offBoundsLeft();

      // end x off left
    } else if (x > right) {
      if (boundsCheckType == BOUNDS_STOP)
        stopRight();

      if (offBoundsRight != null)
        offBoundsRight();

      // end x off right
    }

    if (y < top) {
      if (boundsCheckType == BOUNDS_STOP)
        stopTop();

      if (offBoundsTop != null)
        offBoundsTop();

      // end y off top
    } else if (y > bottom) {
      if (boundsCheckType == BOUNDS_STOP)
        stopBottom();

      if (offBoundsBottom != null)
        offBoundsBottom();
      // end y off bottom
    }

    // end checkBounds
  }

  // end class Kinematics2DComponent
}
