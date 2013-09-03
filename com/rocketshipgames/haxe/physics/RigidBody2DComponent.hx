package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.component.ComponentHandle;


enum RigidBody2DType {
  RIGID_CIRCLE;
  RIGID_BOX;
}


class RigidBody2DComponent
  implements Extent2D
  implements com.rocketshipgames.haxe.component.Component
             
{

  public static var CID:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("rigid-body-2d");


  //------------------------------------------------------------
  public var container(default, null):ComponentHandle;

  public var type(default,null):RigidBody2DType;

  public var radius(default,null):Float;

  public var width(default,null):Float;
  public var height(default,null):Float;

  public var position(default,null):Position2D;

  /*
  public var offsetX:Float;
  public var offsetY:Float;
  */

  public var mass:Float;
  public var restitution:Float;

  public var staticFriction:Float;
  public var dynamicFriction:Float;

  public var collidesAs:Int;
  public var collidesWith:Int;

  public var fixed:Bool;

  //--------------------------------------------------------------------
  private function new():Void
  {

    mass = 1.0;
    restitution = 0.8;

    staticFriction = 0.3;
    dynamicFriction = 0.1;

    fixed = false;

    // end new
  }

  //----------------------------------------------------
  public static function newCircleBody(radius:Float,
                                       collidesAs:Int,
                                       collidesWith:Int,
                                       ?opts:Dynamic):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_CIRCLE;

    x.radius = radius;

    x.width = radius*2;
    x.height = radius*2;

    x.collidesAs = collidesAs;
    x.collidesWith = collidesWith;

    x.activate(opts);

    return x;
    // end newCircleBody
  }

  //----------------------------------------------------
  public static function newBoxBody(width:Float, height:Float,
                                    collidesAs:Int,
                                    collidesWith:Int,
                                    ?opts:Dynamic):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_BOX;

    x.radius = -1;

    x.width = width;
    x.height = height;

    x.collidesAs = collidesAs;
    x.collidesWith = collidesWith;

    x.activate(opts);

    return x;
    // end newBoxBody
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    this.container = container;
    container.claim(PhysicsCapabilities.CID_EXTENT2D);
    container.claim(CID);

    position =
      cast(container.find(PhysicsCapabilities.CID_POSITION2D), Position2D);

    // end attach
  }

  public function detach():Void {}


  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    if (opts == null)
      return;

    var d:Dynamic;

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

  public function deactivate():Void {}


  //----------------------------------------------------
  public function update(millis:Int):Void {}


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function checkCollision(b:RigidBody2DComponent,
                                 manifold:ImpulseCollisionManifold):Bool
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
                                       manifold:ImpulseCollisionManifold):Bool
  {

    var normX = (b.position.x - position.x);
    var normY = (b.position.y - position.y);

    var distSqr = (normX * normX) + (normY * normY);
    var abradius = b.radius + radius;

    if (distSqr > abradius * abradius)
      return false;

    var dist = Math.sqrt(distSqr);

    if (dist == 0) {
      manifold.penetration = radius;
      manifold.normX = 0;
      manifold.normY = -1;
    } else {
      manifold.penetration = abradius - dist;  // Guaranteed to be positive
      manifold.normX = normX / dist;
      manifold.normY = normY / dist;
    }

    return true;

    // end checkCircleVsCircle
  }

  //----------------------------------------------------
  private function checkCircleVsBox(b:RigidBody2DComponent,
                                    manifold:ImpulseCollisionManifold):Bool
  {

    var closestX = clamp(position.x, b.left(), b.right());
    var closestY = clamp(position.y, b.top(), b.bottom());

    var inside = false;
    if (closestX == position.x && closestY == position.y) {
      inside = true;

      if (Math.abs(b.position.x - position.x) >
          Math.abs(b.position.y - position.y)) {

        if (position.x - b.left() > b.right()-position.x)
          closestX = b.right();
        else
          closestX = b.left();

      } else {

        if (position.y - b.top() > b.bottom()-position.y)
          closestY = b.bottom();
        else
          closestY = b.top();

      }

      // end inside
    }


    var dx = position.x - closestX;
    var dy = position.y - closestY;

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
      }

    } else {
      manifold.penetration = radius;
      manifold.normX = 0;
      manifold.normY = -1;
    }

    /*
    trace("Hit circle " + position.x + "," + position.y + 
          " box " + b.position.x + "," + b.position.y +
          "  closest " + closestX + "," + closestY +
          "  norm " + manifold.normX + "," + manifold.normY +
          "  d " + d +
          "  pen " + manifold.penetration);
    */

    return true;

    // end checkCircleVsBox
  }

  //----------------------------------------------------
  private function checkBoxVsCircle(b:RigidBody2DComponent,
                                    manifold:ImpulseCollisionManifold):Bool
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
                                 manifold:ImpulseCollisionManifold):Bool
  {

    var normX = b.position.x - position.x;
    var normY = b.position.y - position.y;

    var overlapX = (width/2) + (b.width/2) - Math.abs(normX);
    if (overlapX < 0)
      return false;

    var overlapY = (height/2) + (b.height/2) - Math.abs(normY);
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
    trace(" a " + position.x + "," + position.y +
          " b " + b.position.x + "," + b.position.y +
          " norm " + normX + "," + normY +
          " overlap " + overlapX + "," + overlapY +
          " norm " + manifold.normX + "," + manifold.normY +
          " pen " + manifold.penetration);
    */

    return true;

    // end checkBoxVsBox
  }

  private function clamp(x:Float, min:Float, max:Float):Float
  {
    if (x > max)
      return max;

    if (x < min)
      return min;

    return x;
    // end clamp
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function left():Float
  {
    return position.x - width/2;
  }

  public function right():Float
  {
    return position.x + width/2;
  }

  public function top():Float
  {
    return position.y - height/2;
  }

  public function bottom():Float
  {
    return position.y + height/2;
  }

  // end RigidBody2DComponent
}
