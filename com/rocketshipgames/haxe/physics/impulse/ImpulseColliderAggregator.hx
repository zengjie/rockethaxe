package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;


class ImpulseColliderAggregator
  implements Component
{

  public var iterations:Int = 8;

  //--------------------------------------------------------------------
  private var colliders:DoubleLinkedList<ImpulseCollider>;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    colliders = new DoubleLinkedList();
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

    var curr:DoubleLinkedListHandle<ImpulseCollider>;

    for (i in 0...iterations) {
      // This loop is laid out explicitly so an iterator isn't created
      curr = colliders.head;
      while (curr != null) {
        curr.item.update(millis);
        curr = curr.next;
      }

    }

    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(collider:ImpulseCollider):Void
  {
    collider.iterations = 1; // Subsume into iterations across all colliders
    colliders.add(collider);
    // end add
  }

  public function addEntity(entity:ComponentContainer):Void
  {
    for (c in colliders)
      c.add(entity);
    // end add
  }

  // end ImpulseColliderAggregator
}
