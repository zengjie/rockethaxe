package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;


class RigidBodyImpulseComponent
  implements Component
  implements com.rocketshipgames.haxe.ds.SweepScanEntity
{

  private var container:RigidBodyImpulseCollisionContainer;
  private var entity:ComponentHandle;

  public var kinematics(default,null):Kinematics2DComponent;
  public var body(default,null):RigidBody2DComponent;

  private var handle:DoubleLinkedListHandle<RigidBodyImpulseComponent>;


  public function new(container:RigidBodyImpulseCollisionContainer):Void
  {
    this.container = container;
  }


  //--------------------------------------------------------------------
  public function attach(entity:ComponentHandle):Void
  {
    this.entity = entity;

    kinematics =
      cast(entity.find(Kinematics2DComponent.CID), Kinematics2DComponent);

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

  public function top():Float { return body.top(); }
  public function bottom():Float { return body.bottom(); }

  public function collidesAs():Int { return body.collidesAs; }
  public function collidesWith():Int { return body.collidesWith; }

  // end RigidBodyImpulseComponent
}
