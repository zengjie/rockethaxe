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


  //--------------------------------------------------------------------
  private function new():Void
  {

    mass = 1.0;
    restitution = 0.8;

    staticFriction = 0.3;
    dynamicFriction = 0.1;

    // end new
  }

  //----------------------------------------------------
  public static function newCircleBody(radius:Float,
                                       collidesAs:Int,
                                       collidesWith:Int):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_CIRCLE;

    x.radius = radius;

    x.width = radius*2;
    x.height = radius*2;

    x.collidesAs = collidesAs;
    x.collidesWith = collidesWith;

    return x;
    // end newCircleBody
  }

  //----------------------------------------------------
  public static function newBoxBody(width:Float, height:Float,
                                    collidesAs:Int,
                                    collidesWith:Int):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_BOX;

    x.width = width;
    x.height = height;

    x.collidesAs = collidesAs;
    x.collidesWith = collidesWith;

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
  public function activate(?opts:Dynamic):Void {}

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

      //default:
      //Debug.error("Circle rigid body cannot be compared to type " + b.type);
      }

    case RIGID_BOX:
      switch (b.type) {
      case RIGID_CIRCLE:

      case RIGID_BOX:

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

    if (distSqr >= abradius * abradius)
      return false;

    var dist = Math.sqrt(distSqr);

    if (dist == 0) {
      manifold.penetration = radius;
      manifold.normX = 0;
      manifold.normY = 1;
    } else {
      manifold.penetration = abradius - dist;  // Guaranteed to be positive
      manifold.normX = normX / dist;
      manifold.normY = normY / dist;
    }

    return true;

    // end checkCircleVsCircle
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
