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

  public var penetrationThreshold:Float;
  public var correctionPercent:Float;


  //----------------------------------------------------
  private var deadpool:Dynamic;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    correctionPercent = 0.9;
    penetrationThreshold = 0.0001;
      // 1/com.rocketshipgames.haxe.device.Display.defaultPixelsPerMeter;
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

    var invMassSum = (a.invMass + b.invMass);

    // Bounce

    var e = Math.min(a.restitution, b.restitution);

    var j = (-(1 + e) * vel) / invMassSum;

    var impX = j * normX;
    var impY = j * normY;

    if (!a.fixed) {
      a.xvel -= a.invMass * impX;
      a.yvel -= a.invMass * impY;
    }

    if (!b.fixed) {
      b.xvel += b.invMass * impX;
      b.yvel += b.invMass * impY;
    }

    // Recompute as these have now changed
    rvx = b.xvel - a.xvel;
    rvy = b.yvel - a.yvel;


    // Friction
    var tx = rvx - (rvx*normX)+(rvy*normY)*normX;
    var ty = rvy - (rvx*normX)+(rvy*normY)*normY;

      var td = Math.sqrt((tx*tx)+(ty*ty));

      if (td != 0) {

      tx /= td;
      ty /= td;


      var jt = -((rvx*tx)+(rvy*ty)) / invMassSum;

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
        a.xvel -= a.invMass * ix;
        a.yvel -= a.invMass * iy;
      }

      if (!b.fixed) {
        b.xvel += b.invMass * ix;
        b.yvel += b.invMass * iy;
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

    if (penetration > penetrationThreshold) {
      var correctionX = (penetration / invMassSum) * normX * correctionPercent;

      var correctionY = (penetration / invMassSum) * normY * correctionPercent;

      /*
      trace("Penetration " + penetration +
            "  Correction " + correctionX + "," + correctionY +
            "  Norm " + normX + "," + normY);
      */

      if (!a.fixed) {
        /*
        var cx = a.invMass * correctionX;
        var cy = a.invMass * correctionY;

        if (Math.abs(cx) > penetrationThreshold)
          a.x -= cx;

        if (Math.abs(cy) > penetrationThreshold)
          a.y -= cy;
        */

        a.x -= a.invMass * correctionX;
        a.y -= a.invMass * correctionY;
      }

      if (!b.fixed) {
        /*
        var cx = b.invMass * correctionX;
        var cy = b.invMass * correctionY;

        if (Math.abs(cx) > penetrationThreshold)
          b.x += cx;

        if (Math.abs(cy) > penetrationThreshold)
          b.y += cy;
        */

        b.x += b.invMass * correctionX;
        b.y += b.invMass * correctionY;
      }

    }

    // end apply
  }

  // end ImpulseManifold
}
