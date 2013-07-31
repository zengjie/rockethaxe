/*
 * Copyright (c) 2012 Joe Kopena <tjkopena@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/

package com.rocketshipgames.haxe.physics.packages;

enum BoundsBehavior {
  BOUNDS_NONE;
  BOUNDS_DETECT;
  BOUNDS_STOP;
}

class ShooterPhysicsPackage
  extends PhysicsPackage {

  public var boundsCheckType:BoundsBehavior;

  public var left:Float;
  public var top:Float;

  public var right:Float;
  public var bottom:Float;

  public var offBoundsLeft:Void->Void;
  public var offBoundsRight:Void->Void;
  public var offBoundsTop:Void->Void;
  public var offBoundsBottom:Void->Void;

  //------------------------------------------------------------------
  public function new(parent:PhysicalEntity):Void
  {
    super(parent);

    boundsCheckType = BOUNDS_NONE;
    offBoundsLeft = null;
    offBoundsRight = null;
    offBoundsTop = null;
    offBoundsBottom = null;

    // end ShooterPhysicsPackage
  }

  //------------------------------------------------------------------
  public override function update(millis:Int):Void
  {

    var elapsed:Float = millis/1000.0;
    // trace("Elapsed " + elapsed + "; millis " + millis);

    //-------
    // x
    if (xacc == 0) {
      // trace("xacc 0");
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
      // trace("xacc not 0---" + xacc + "; min " + xvelMin +"; " + xvel);
      if (Math.abs(xvel) < xvelMin) {
	// trace("abs");
	xvel = 0;
      } else if (xvel < -xvelMax)
	xvel = -xvelMax;
      else if (xvel > xvelMax)
	xvel = xvelMax;
    }

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


    parent.x += xvel*elapsed;
    parent.y += yvel*elapsed;

    checkBounds();

    // end update
  }

  public function setBounds(?type:BoundsBehavior=null,
			    ?left:Float = 0,
			    ?top:Float = 0,
			    ?right:Float = 0,
			    ?bottom:Float = 0,
                            ?world:World = null):Void
  {
    if (type == null) type = BOUNDS_NONE;
    if (right == 0 && world != null) right = world.worldWidth;
    if (bottom == 0 && world != null) bottom = world.worldHeight;

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
      parent.x = left;
      xvel = 0;
    }
  }
  public function cannotLeaveRight():Void
  {
    if (xvel >= 0) {
      parent.x = right;
      xvel = 0;
    }
  }
  public function cannotLeaveTop():Void
  {
    if (yvel <= 0) {
      parent.y = top;
      yvel = 0;
    }
  }
  public function cannotLeaveBottom():Void
  {
    if (yvel >= 0) {
      parent.y = bottom;
      yvel = 0;
    }
  }

  //------------------------------------------------------------
  public function stopLeft():Void
  {
    parent.x = left;
    xvel = 0;
  }
  public function stopRight():Void
  {
    parent.x = right;
    xvel = 0;
  }
  public function stopTop():Void
  {
    parent.y = top;
    yvel = 0;
  }
  public function stopBottom():Void
  {
    parent.y = bottom;
    yvel = 0;
  }

  //------------------------------------------------------------
  public function cycleLeft():Void
  {
    parent.x = right;
  }
  public function cycleRight():Void
  {
    parent.x = left;
  }
  public function cycleTop():Void
  {
    parent.y = bottom;
  }
  public function cycleBottom():Void
  {
    parent.y = top;
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function checkBounds():Void
  {

    if (boundsCheckType == BOUNDS_NONE)
      return;

    if (parent.x < left) {
      if (boundsCheckType == BOUNDS_STOP)
        stopLeft();

      if (offBoundsLeft != null)
        offBoundsLeft();

      // end x off left
    } else if (parent.x > right) {
      if (boundsCheckType == BOUNDS_STOP)
        stopRight();

      if (offBoundsRight != null)
        offBoundsRight();

      // end x off right
    }

    if (parent.y < top) {
      if (boundsCheckType == BOUNDS_STOP)
        stopTop();

      if (offBoundsTop != null)
        offBoundsTop();

      // end y off top
    } else if (parent.y > bottom) {
      if (boundsCheckType == BOUNDS_STOP)
        stopBottom();

      if (offBoundsBottom != null)
        offBoundsBottom();
      // end y off bottom
    }

    // end checkBounds
  }

  // end class ShooterPhysicsPackage
}
