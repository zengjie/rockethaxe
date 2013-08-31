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

  private var broadphase:SweepScanBroadphase<RigidBodyImpulseComponent,Float>;


  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new DoubleLinkedList();
    broadphase = new SweepScanBroadphase(resolveCollision, earlier);
    // end new
  }

  private function earlier(a:Float, b:Float):Bool { return a < b; }


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


    // Friction

    rvx = manifold.b.kinematics.xvel - manifold.a.kinematics.xvel;
    rvy = manifold.b.kinematics.yvel - manifold.a.kinematics.yvel;

    var tx = rvx - (rvx*manifold.normX)+(rvy*manifold.normY)*manifold.normX;
    var ty = rvy - (rvx*manifold.normX)+(rvy*manifold.normY)*manifold.normY;
    var td = Math.sqrt((tx*tx)+(ty*ty));
    if (td != 0) {
    tx /= td;
    ty /= td;

    var jt = -((rvx*tx)+(rvy*ty));
    jt /= (1/manifold.a.body.mass) + (1/manifold.b.body.mass);


    var staticFric = 0.3;
    var dynamicFric = 0.1;

    var sf = Math.sqrt(staticFric * staticFric);
    var df = Math.sqrt(dynamicFric * dynamicFric);
 
    var ix:Float;
    var iy:Float;

    if (Math.abs(jt) < j * sf) {
      ix = jt * tx;
      iy = jt * ty;
    } else {
      ix = tx * -j * df;
      iy = ty * -j * df;
    }

    manifold.a.kinematics.xvel -= (1/manifold.a.body.mass) * ix;
    manifold.a.kinematics.yvel -= (1/manifold.a.body.mass) * iy;

    manifold.b.kinematics.xvel += (1/manifold.b.body.mass) * ix;
    manifold.b.kinematics.yvel += (1/manifold.b.body.mass) * iy;
    }


    /*
    var motion = (manifold.a.kinematics.xvel*manifold.a.kinematics.xvel)+
      (manifold.a.kinematics.yvel*manifold.a.kinematics.yvel);
    trace("Motion A " + motion +
          "  vel " + manifold.a.kinematics.xvel + "," + manifold.a.kinematics.yvel);
      //      manifold.a.kinematics.xvel = manifold.a.kinematics.yvel = 0;

    motion = (manifold.b.kinematics.xvel*manifold.b.kinematics.xvel)+
      (manifold.b.kinematics.yvel*manifold.b.kinematics.yvel);
    trace("Motion A " + motion +
          "  vel " + manifold.b.kinematics.xvel + "," + manifold.b.kinematics.yvel);
      //      manifold.b.kinematics.xvel = manifold.b.kinematics.yvel = 0;
      */


    // Position correction
    var percent:Float = 0.6;
    var threshold:Float = 2;

    if (manifold.penetration > threshold) {
      var correctionX = ((manifold.penetration - threshold) /
                         ((1/manifold.a.body.mass) + (1/manifold.b.body.mass)))
        * manifold.normX * percent;

      var correctionY = ((manifold.penetration - threshold) /
                         ((1/manifold.a.body.mass) + (1/manifold.b.body.mass)))
        * manifold.normY * percent;

      /*
      trace("Penetration " + manifold.penetration +
            "  Correction " + correctionX + "," + correctionY +
            "  Norm " + manifold.normX + "," + manifold.normY);
      */

      manifold.a.kinematics.x -= (1/manifold.a.body.mass) * correctionX;
      manifold.a.kinematics.y -= (1/manifold.a.body.mass) * correctionY;

      manifold.b.kinematics.x += (1/manifold.b.body.mass) * correctionX;
      manifold.b.kinematics.y += (1/manifold.b.body.mass) * correctionY;
    }




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
