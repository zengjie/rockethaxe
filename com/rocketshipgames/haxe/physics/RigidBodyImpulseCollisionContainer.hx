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

  private var manifold:ImpulseCollisionManifold;


  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new DoubleLinkedList();
    broadphase = new SweepScanBroadphase(resolveCollision, earlier);

    manifold = new ImpulseCollisionManifold();
    // end new
  }

  private function earlier(a:Float, b:Float):Bool { return a < b; }


  //----------------------------------------------------
  public function attach(container:ComponentHandle):Void
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

    if (!a.body.checkCollision(b.body, manifold))
      return;

    manifold.a = a;
    manifold.b = b;

    manifold.apply();

    // end resolveCollision
  }

  // end RigidBodyImpulseCollisionContainer
}
