package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;


class ImpulseCollider
  implements Component
{

  public var iterations:Int = 8;

  //--------------------------------------------------------------------
  @:allow(com.rocketshipgames.haxe.physics.impulse.ImpulseComponent)
  private var group:DoubleLinkedList<ImpulseComponent>;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new DoubleLinkedList();
    // end new
  }


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
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer):Void
  {
    entity.add(new ImpulseComponent(this));
    // end add
  }

  // end ImpulseCollider
}
