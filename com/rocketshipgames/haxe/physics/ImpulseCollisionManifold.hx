package com.rocketshipgames.haxe.physics;


class ImpulseCollisionManifold
{

  public var a:RigidBodyImpulseComponent;
  public var b:RigidBodyImpulseComponent;

  public var normX:Float;
  public var normY:Float;

  public var penetration:Float;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    // end new
  }


  //----------------------------------------------------
  public function apply():Void
  {

    var rvx = b.kinematics.xvel - a.kinematics.xvel;
    var rvy = b.kinematics.yvel - a.kinematics.yvel;

    var vel = (rvx * normX) + (rvy * normY);

    // Do not do anything if already moving apart
    if (vel > 0)
      return;

    var e = Math.min(b.body.restitution,
                     a.body.restitution);

    var j = (-(1 + e) * vel) /
      ((1/a.body.mass) + (1/b.body.mass));

    var impX = j * normX;
    var impY = j * normY;

    a.kinematics.xvel -= (1/a.body.mass) * impX;
    a.kinematics.yvel -= (1/a.body.mass) * impY;

    b.kinematics.xvel += (1/b.body.mass) * impX;
    b.kinematics.yvel += (1/b.body.mass) * impY;


    // Friction
    rvx = b.kinematics.xvel - a.kinematics.xvel;
    rvy = b.kinematics.yvel - a.kinematics.yvel;

    var tx = rvx - (rvx*normX)+(rvy*normY)*normX;
    var ty = rvy - (rvx*normX)+(rvy*normY)*normY;
    var td = Math.sqrt((tx*tx)+(ty*ty));

    if (td != 0) {
      tx /= td;
      ty /= td;

      var jt = -((rvx*tx)+(rvy*ty));
      jt /= (1/a.body.mass) + (1/b.body.mass);


      var sf = Math.sqrt
        ((a.body.staticFriction * a.body.staticFriction) +
         (b.body.staticFriction * b.body.staticFriction));
 
      var ix:Float;
      var iy:Float;

      if (Math.abs(jt) < j * sf) {
        ix = jt * tx;
        iy = jt * ty;
      } else {
        var df = Math.sqrt
          ((a.body.dynamicFriction * a.body.dynamicFriction) +
           (b.body.dynamicFriction * b.body.dynamicFriction));
        ix = tx * -j * df;
        iy = ty * -j * df;
      }

      a.kinematics.xvel -= (1/a.body.mass) * ix;
      a.kinematics.yvel -= (1/a.body.mass) * iy;

      b.kinematics.xvel += (1/b.body.mass) * ix;
      b.kinematics.yvel += (1/b.body.mass) * iy;
    }


    /*
    var motion = (a.kinematics.xvel*a.kinematics.xvel)+
      (a.kinematics.yvel*a.kinematics.yvel);
    trace("Motion A " + motion +
          "  vel " + a.kinematics.xvel + "," + a.kinematics.yvel);
      //      a.kinematics.xvel = a.kinematics.yvel = 0;

    motion = (b.kinematics.xvel*b.kinematics.xvel)+
      (b.kinematics.yvel*b.kinematics.yvel);
    trace("Motion A " + motion +
          "  vel " + b.kinematics.xvel + "," + b.kinematics.yvel);
      //      b.kinematics.xvel = b.kinematics.yvel = 0;
      */


    // Position correction
    var percent:Float = 0.8;
    var threshold:Float = 1;

    if (penetration > threshold) {
      var correctionX = ((penetration - threshold) /
                         ((1/a.body.mass) + (1/b.body.mass)))
        * normX * percent;

      var correctionY = ((penetration - threshold) /
                         ((1/a.body.mass) + (1/b.body.mass)))
        * normY * percent;

      /*
      trace("Penetration " + penetration +
            "  Correction " + correctionX + "," + correctionY +
            "  Norm " + normX + "," + normY);
      */

      a.kinematics.x -= (1/a.body.mass) * correctionX;
      a.kinematics.y -= (1/a.body.mass) * correctionY;

      b.kinematics.x += (1/b.body.mass) * correctionX;
      b.kinematics.y += (1/b.body.mass) * correctionY;
    }

    // end apply
  }

  // end ImpulseCollisionManifold
}
