package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.ds.DeadpoolObject;

import com.rocketshipgames.haxe.physics.CollisionManifold2D;
import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;


class ImpulseManifold
  implements CollisionManifold2D
  implements DeadpoolObject
{

  public var a:RigidBody2DComponent;
  public var b:RigidBody2DComponent;

  public var normX:Float;
  public var normY:Float;

  public var penetration:Float;

  //----------------------------------------------------
  private var deadpool:Dynamic;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    // end new
  }

  public function init(?opts:Dynamic):Void
  {
  }

  //----------------------------------------------------
  public function setDeadpool(deadpool:Dynamic):Void
  {
    this.deadpool = deadpool;
  }

  public function repool():Void
  {
    deadpool.returnObject(this);
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function apply():Void
  {

    var rvx = b.xvel - a.xvel;
    var rvy = b.yvel - a.yvel;

    var vel = (rvx * normX) + (rvy * normY);

    // Do not do anything if already moving apart
    if (vel > 0)
      return;

    var e = Math.min(b.restitution,
                     a.restitution);

    var j = (-(1 + e) * vel) /
      ((1/a.mass) + (1/b.mass));

    var impX = j * normX;
    var impY = j * normY;

    if (!a.fixed) {
      a.xvel -= (1/a.mass) * impX;
      a.yvel -= (1/a.mass) * impY;
    }

    if (!b.fixed) {
      b.xvel += (1/b.mass) * impX;
      b.yvel += (1/b.mass) * impY;
    }


    // Friction
    rvx = b.xvel - a.xvel;
    rvy = b.yvel - a.yvel;

    var tx = rvx - (rvx*normX)+(rvy*normY)*normX;
    var ty = rvy - (rvx*normX)+(rvy*normY)*normY;
    var td = Math.sqrt((tx*tx)+(ty*ty));

    if (td != 0) {
      tx /= td;
      ty /= td;

      var jt = -((rvx*tx)+(rvy*ty));
      jt /= (1/a.mass) + (1/b.mass);


      var sf = Math.sqrt
        ((a.staticFriction * a.staticFriction) +
         (b.staticFriction * b.staticFriction));
 
      var ix:Float;
      var iy:Float;

      if (Math.abs(jt) < j * sf) {
        ix = jt * tx;
        iy = jt * ty;
      } else {
        var df = Math.sqrt
          ((a.dynamicFriction * a.dynamicFriction) +
           (b.dynamicFriction * b.dynamicFriction));
        ix = tx * -j * df;
        iy = ty * -j * df;
      }

      if (!a.fixed) {
        a.xvel -= (1/a.mass) * ix;
        a.yvel -= (1/a.mass) * iy;
      }

      if (!b.fixed) {
        b.xvel += (1/b.mass) * ix;
        b.yvel += (1/b.mass) * iy;
      }

    }


    /*
    var motion = (a.xvel*a.xvel)+
      (a.yvel*a.yvel);
    trace("Motion A " + motion +
          "  vel " + a.xvel + "," + a.yvel);
      //      a.xvel = a.yvel = 0;

    motion = (b.xvel*b.xvel)+
      (b.yvel*b.yvel);
    trace("Motion A " + motion +
          "  vel " + b.xvel + "," + b.yvel);
      //      b.xvel = b.yvel = 0;
      */


    // Position correction
    var percent:Float = 0.9;
    var threshold:Float = 0.0001;

    if (penetration > threshold) {
      var correctionX = ((penetration - threshold) /
                         ((1/a.mass) + (1/b.mass)))
        * normX * percent;

      var correctionY = ((penetration - threshold) /
                         ((1/a.mass) + (1/b.mass)))
        * normY * percent;

      /*
      trace("Penetration " + penetration +
            "  Correction " + correctionX + "," + correctionY +
            "  Norm " + normX + "," + normY);
      */

      if (!a.fixed) {
        a.x -= (1/a.mass) * correctionX;
        a.y -= (1/a.mass) * correctionY;
      }

      if (!b.fixed) {
        b.x += (1/b.mass) * correctionX;
        b.y += (1/b.mass) * correctionY;
      }

    }

    // end apply
  }

  // end ImpulseManifold
}
