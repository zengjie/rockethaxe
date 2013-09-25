package com.rocketshipgames.haxe.physics.core2d;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.Extent2D;
import com.rocketshipgames.haxe.physics.CollisionManifold2D;


enum RigidBody2DType {
  RIGID_CIRCLE;
  RIGID_BOX;
}


class RigidBody2DComponent
  extends Kinematics2DComponent
  implements Extent2D
{

  public static var CID:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("cid_rigidbody2d");


  //------------------------------------------------------------
  public var type:RigidBody2DType;

  public var width:Float;
  public var height:Float;

  public var offsetX:Float;
  public var offsetY:Float;

  public var mass:Float;
  public var restitution:Float;

  public var staticFriction:Float;
  public var dynamicFriction:Float;

  public var collidesAs:Int;
  public var collidesWith:Int;

  public var fixed:Bool;

  //--------------------------------------------------------------------
  private var container:ComponentHandle;

  private var radius:Float;


  //--------------------------------------------------------------------
  private function new():Void
  {
    super();

    radius = width = height = 0.0;
    offsetX = offsetY = 0.0;

    mass = 1.0;
    restitution = 0.8;

    staticFriction = 0.3;
    dynamicFriction = 0.1;

    fixed = false;

    // end new
  }

  //----------------------------------------------------
  public static function newCircleBody(radius:Float,
                                       ?opts:Dynamic):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_CIRCLE;

    x.radius = radius;
    x.width = radius*2;
    x.height = radius*2;

    x.activate(opts);

    return x;
    // end newCircleBody
  }

  //----------------------------------------------------
  public static function newBoxBody(width:Float, height:Float,
                                    ?opts:Dynamic):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_BOX;

    x.width = width;
    x.height = height;

    x.activate(opts);

    return x;
    // end newBoxBody
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public override function attach(container:ComponentHandle):Void
  {
    super.attach(container);

    this.container = container;
    container.claim(PhysicsCapabilities.CID_EXTENT2D);
    container.claim(CID);

    // end attach
  }


  //----------------------------------------------------
  public override function activate(?opts:Dynamic):Void
  {

    super.activate(opts);

    if (opts == null)
      return;

    var d:Dynamic;

    if ((d = Reflect.field(opts, "offsetX")) != null) {
      offsetX = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "offsetY")) != null) {
      offsetY = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "mass")) != null) {
      mass = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "restitution")) != null) {
      restitution = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "staticFriction")) != null) {
      staticFriction = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "dynamicFriction")) != null) {
      dynamicFriction = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "collidesAs")) != null) {
      collidesAs = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    if ((d = Reflect.field(opts, "collidesWith")) != null) {
      collidesWith = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    if ((d = Reflect.field(opts, "fixed")) != null) {
      fixed = (Std.is(d, String)) ? ((d=="true")?true:false) : d;
    }

    // end activate
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function checkCollision(b:RigidBody2DComponent,
                                 manifold:CollisionManifold2D):Bool
  {

    switch (type) {
    case RIGID_CIRCLE:
      switch (b.type) {
      case RIGID_CIRCLE:
        return checkCircleVsCircle(b, manifold);

      case RIGID_BOX:
        return checkCircleVsBox(b, manifold);

      //default:
      //Debug.error("Circle rigid body cannot be compared to type " + b.type);
      }

    case RIGID_BOX:
      switch (b.type) {
      case RIGID_CIRCLE:
        return checkBoxVsCircle(b, manifold);

      case RIGID_BOX:
        return checkBoxVsBox(b, manifold);

      //default:
      //Debug.error("Circle rigid body cannot be compared to type " + b.type);
      }

    //default:
    //Debug.error("Rigid body has unknown type " + type);
    }

    return false;

    // end checkCollision
  }

  //----------------------------------------------------
  private function checkCircleVsCircle(b:RigidBody2DComponent,
                                       manifold:CollisionManifold2D):Bool
  {

    var normX = (b.x - x);
    var normY = (b.y - y);

    var distSqr = (normX * normX) + (normY * normY);
    var abradius = b.radius + radius;

    if (distSqr > (abradius * abradius) - 0.01)
      return false;

    var dist = Math.sqrt(distSqr);

    if (dist <= 0.01) {
      manifold.penetration = radius;
      manifold.normX = 0;
      manifold.normY = -1;
    } else {
      manifold.penetration = abradius - dist;  // Guaranteed to be positive
      manifold.normX = normX / dist;
      manifold.normY = normY / dist;
    }

    /*
    trace("Manifold " + manifold.normX + "," + manifold.normY +
          " pen " + manifold.penetration);
    */

    return true;

    // end checkCircleVsCircle
  }

  //----------------------------------------------------
  private function checkCircleVsBox(b:RigidBody2DComponent,
                                    manifold:CollisionManifold2D):Bool
  {

    var closestX = clamp(x, b.left(), b.right());
    var closestY = clamp(y, b.top(), b.bottom());

    var inside = false;
    if (closestX == x && closestY == y) {
      inside = true;

      var dleft = x - b.left();
      var dright = b.right() - x;

      var dtop = y - b.top();
      var dbottom = b.bottom() - y;

      if (Math.min(dleft, dright) < Math.min(dtop, dbottom)) {

        if (dleft < dright)
          closestX = b.left();
        else
          closestX = b.right();

      } else {

        if (dtop < dbottom)
          closestY = b.top();
        else
          closestY = b.bottom();

      }

      // end inside
    }


    var dx = x - closestX;
    var dy = y - closestY;

    var distSqr = (dx * dx) + (dy * dy);

    if (!inside && distSqr > radius*radius)
      return false;

    var d = Math.sqrt(distSqr);

    if (d != 0) {
      manifold.penetration = radius-d;
      manifold.normX = -dx/d;
      manifold.normY = -dy/d;

      if (inside) {
        manifold.normX *= -1;
        manifold.normY *=-1;
        manifold.penetration = d;

        /*
        trace("INSIDE Hit circle " + x + "," + y + 
              " box " + b.x + "," + b.y +
              "  closest " + closestX + "," + closestY +
              "  norm " + manifold.normX + "," + manifold.normY +
              "  d " + d +
              "  pen " + manifold.penetration);
        */

      }

    } else {
      manifold.penetration = radius;
      manifold.normX = 0;
      manifold.normY = -1;
    }

    return true;

    // end checkCircleVsBox
  }

  //----------------------------------------------------
  private function checkBoxVsCircle(b:RigidBody2DComponent,
                                    manifold:CollisionManifold2D):Bool
  {
    if (!b.checkCircleVsBox(this, manifold))
      return false;

    manifold.normX *= -1;
    manifold.normY *= -1;

    return true;
    // end checkBoxVsCircle
  }

  //----------------------------------------------------
  private function checkBoxVsBox(b:RigidBody2DComponent,
                                 manifold:CollisionManifold2D):Bool
  {

    var normX:Float = b.x - x;
    var normY:Float = b.y - y;

    var overlapX:Float = (width/2) + (b.width/2) - ((normX>0)?normX:-normX);
    if (overlapX < 0)
      return false;

    var overlapY:Float = (height/2) + (b.height/2) - ((normY>0)?normY:-normY);
    if (overlapY < 0)
      return false;

    if (overlapX < overlapY) {

      if (normX < 0)
        manifold.normX = -1;
      else
        manifold.normX = 1;

      manifold.normY = 0;
      manifold.penetration = overlapX;

    } else {

      if (normY <= 0)
        manifold.normY = -1;
      else
        manifold.normY = 1;

      manifold.normX = 0;
      manifold.penetration = overlapY;

    }

    /*
    trace(" a " + x + "," + y +
          " b " + b.x + "," + b.y +
          " norm " + normX + "," + normY +
          " overlap " + overlapX + "," + overlapY +
          " norm " + manifold.normX + "," + manifold.normY +
          " pen " + manifold.penetration);
    */

    return true;

    // end checkBoxVsBox
  }

  private function clamp(v:Float, min:Float, max:Float):Float
  {
    if (v > max)
      return max;

    if (v < min)
      return min;

    return v;
    // end clamp
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function left():Float
  {
    return x - width/2;
  }

  public function right():Float
  {
    return x + width/2;
  }

  public function top():Float
  {
    return y - height/2;
  }

  public function bottom():Float
  {
    return y + height/2;
  }

  // end RigidBody2DComponent
}
