package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.ds.SweepScanBroadphase;
import com.rocketshipgames.haxe.ds.SweepScanEntity;


class ImpulseObjectCollider
  extends ImpulseCollider
{

  //--------------------------------------------------------------------
  private var broadphase:SweepScanBroadphase<ImpulseComponent,Float>;

  private var manifold:ImpulseManifold;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    super();

    broadphase = new SweepScanBroadphase(resolveCollision, earlier);

    /*
     * Manifold persists rather than being a local variable so we're
     * not creating a new object every frame.
     */
    manifold = new ImpulseManifold();

    // end new
  }

  private function earlier(a:Float, b:Float):Bool { return a < b; }


  //----------------------------------------------------
  public override function update(millis:Int):Void
  {
    for (i in 0...iterations)
      broadphase.scan(group);
    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function resolveCollision(a:ImpulseComponent,
                                   b:ImpulseComponent):Void
  {
    var aHit = a.body.collidesWith & b.body.collidesAs;
    var bHit = b.body.collidesWith & a.body.collidesAs;

    // These objects don't collide
    if (aHit == 0 && bHit == 0)
      return;

    if (!a.body.checkCollision(b.body, manifold))
      return;

    manifold.a = a.body;
    manifold.b = b.body;

    manifold.apply();

    // end resolveCollision
  }

  // end ImpulseObjectCollider
}
