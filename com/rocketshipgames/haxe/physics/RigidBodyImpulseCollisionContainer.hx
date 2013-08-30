package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;

import com.rocketshipgames.haxe.ds.SweepScanBroadphase;
import com.rocketshipgames.haxe.ds.SweepScanEntity;


class RigidBodyImpulseCollisionContainer
  implements Component
{

  @:allow(com.rocketshipgames.haxe.physics.RigidBodyImpulseComponent)
  private var group:DoubleLinkedList<RigidBodyImpulseComponent>;

  private var broadphase:SweepScanBroadphase<RigidBodyImpulseComponent>;


  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new DoubleLinkedList();
    broadphase = new SweepScanBroadphase(resolveCollision);
    // end new
  }

  //----------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
  }

  public function detach():Void
  {
  }


  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //----------------------------------------------------
  public function update(millis:Int):Void
  {
    broadphase.scan(group);
    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer):Void
  {
    entity.add(new RigidBodyImpulseComponent(this));
    // end add
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function resolveCollision(a:RigidBodyImpulseComponent,
                                   b:RigidBodyImpulseComponent):Void
  {
    var aHit = a.body.collidesWith & b.body.collidesAs;
    var bHit = b.body.collidesWith & a.body.collidesAs;

    // These objects don't collide
    if (aHit == 0 && bHit == 0)
      return;

    var manifold = checkCollision(a, b);
    if (manifold == null)
      return;

    applyCollision(manifold);

    // end resolveCollision
  }

  //----------------------------------------------------
  private function checkCollision(a:RigidBodyImpulseComponent,
                                 b:RigidBodyImpulseComponent):Manifold
  {
    var res:Manifold = null;

    if (a.body.type == RIGID_CIRCLE &&
        b.body.type == RIGID_CIRCLE) {

      var normX = (b.kinematics.x - a.kinematics.x);
      var normY = (b.kinematics.y - a.kinematics.y);

      var distSqr = (normX * normX) + (normY * normY);
      var radius = b.body.radius + a.body.radius;

      /*
      trace("a " + a.kinematics.x + "," + a.kinematics.y +
            "  b " + b.kinematics.x + "," + b.kinematics.y);
      trace("Radius " + radius + "  d^2 " + distSqr + "  d " + Math.sqrt(distSqr));
      */

      if (distSqr < radius * radius) {
        res = new Manifold(a, b);

        var dist = Math.sqrt(distSqr);

        if (dist == 0) {
          res.penetration = a.body.radius;
          res.normX = 0;
          res.normY = 1;
        } else {
          res.penetration = radius - dist;
          res.normX = normX / dist;
          res.normY = normY / dist;
        }

      }
    }

    return res;

    // end checkCollision
  }

  private function applyCollision(manifold:Manifold):Void
  {

    var rvx = manifold.b.kinematics.xvel - manifold.a.kinematics.xvel;
    var rvy = manifold.b.kinematics.yvel - manifold.a.kinematics.yvel;

    var vel = (rvx * manifold.normX) + (rvy * manifold.normY);

    // Do not do anything if already moving apart
    if (vel > 0)
      return;

    var e = Math.min(manifold.b.body.restitution,
                       manifold.a.body.restitution);

    var j = (-(1 + e) * vel) /
      ((1/manifold.a.body.mass) + (1/manifold.b.body.mass));

    var impX = j * manifold.normX;
    var impY = j * manifold.normY;

    /*
    trace("COLLISION!  a  " +
          manifold.a.kinematics.x + "," +
          manifold.a.kinematics.y + " " +
          manifold.a.kinematics.xvel + "," +
          manifold.a.kinematics.yvel + " " +
          "   b " +
          manifold.b.kinematics.x + "," +
          manifold.b.kinematics.y + " " +
          manifold.b.kinematics.xvel + "," +
          manifold.b.kinematics.yvel + " " +
          "   norm " + manifold.normX + "," + manifold.normY +
          " vel " + vel);
    */

    manifold.a.kinematics.xvel -= (1/manifold.a.body.mass) * impX;
    manifold.a.kinematics.yvel -= (1/manifold.a.body.mass) * impY;

    manifold.b.kinematics.xvel += (1/manifold.b.body.mass) * impX;
    manifold.b.kinematics.yvel += (1/manifold.b.body.mass) * impY;

    // end applyCollision
  }

  // end RigidBodyImpulseCollisionContainer
}


private class Manifold
{
  public var a:RigidBodyImpulseComponent;
  public var b:RigidBodyImpulseComponent;

  public var penetration:Float;
  public var normX:Float;
  public var normY:Float;

  public function new(a:RigidBodyImpulseComponent,
                      b:RigidBodyImpulseComponent):Void
  {
    this.a = a;
    this.b = b;
  }

  // end Manifold
}
