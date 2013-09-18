package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;

import com.rocketshipgames.haxe.ds.SweepScanBroadphase;
import com.rocketshipgames.haxe.ds.SweepScanEntity;


class ImpulseCollisionContainer
  implements Component
{

  public var iterations:Int = 8;

  //--------------------------------------------------------------------
  @:allow(com.rocketshipgames.haxe.physics.impulse.ImpulseComponent)
  private var group:DoubleLinkedList<ImpulseComponent>;

  private var broadphase:SweepScanBroadphase<ImpulseComponent,Float>;

  private var manifold:ImpulseManifold;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new DoubleLinkedList();
    broadphase = new SweepScanBroadphase(resolveCollision, earlier);

    manifold = new ImpulseManifold();
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
    for (i in 0...iterations)
      broadphase.scan(group);
    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer):Void
  {
    entity.add(new ImpulseComponent(this));
    // end add
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

  // end ImpulseCollisionContainer
}
