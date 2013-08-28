package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;


class SweepScanCollisionContainer
  implements Component
{


  //--------------------------------------------------------------------
  public function new():Void
  {
    // end new
  }

  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {
    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer):Void
  {
    var body:RigidBody2DComponent =
      cast(entity.find(RigidBody2DComponent.CID), RigidBody2DComponent);

    // end add
  }

  // end SweepScanCollisionContainer
}
