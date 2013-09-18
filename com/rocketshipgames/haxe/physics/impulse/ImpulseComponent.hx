package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;

import com.rocketshipgames.haxe.ds.SweepScanEntity;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;


class ImpulseComponent
  implements Component
  implements SweepScanEntity<Float>
{

  private var container:ImpulseCollisionContainer;
  private var entity:ComponentHandle;

  private var handle:DoubleLinkedListHandle<ImpulseComponent>;

  public var body(default,null):RigidBody2DComponent;


  public function new(container:ImpulseCollisionContainer):Void
  {
    this.container = container;
  }


  //--------------------------------------------------------------------
  public function attach(entity:ComponentHandle):Void
  {
    this.entity = entity;

    body = cast(entity.find(RigidBody2DComponent.CID), RigidBody2DComponent);

    activate();
    // end attach
  }

  public function detach():Void
  {
    deactivate();
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    handle = container.group.add(this);
  }

  public function deactivate():Void
  {
    handle.remove();
  }

  public function update(elapsed:Int):Void { }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------

  public function begin():Float { return body.top(); }
  public function end():Float { return body.bottom(); }

  // end ImpulseComponent
}