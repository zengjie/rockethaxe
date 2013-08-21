package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.DoubleLinkedListIterator;


class ComponentContainer<T:Component>
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  private var components:DoubleLinkedList<ComponentHandle<T>>;

  private var capabilities:Map<String,ComponentHandle<T>>;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    components = new DoubleLinkedList();
    capabilities = new Map();
    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function addComponent(component:T):ComponentHandle<T>
  {
    var containerHandle = new ComponentHandle<T>
      (this, component);

    var listHandle = components.add(containerHandle);
    containerHandle.listHandle = listHandle;

    component.attach(containerHandle);

    return containerHandle;
    // end addComponent
  }

  public function removeComponent(handle:ComponentHandle<T>):Void
  {
    components.remove(handle.listHandle);
    handle.component.detach();
    // end removeComponent
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function claimCapability(capability:String,
                                  component:ComponentHandle<T>):Void
  {
    capabilities.set(capability, component);
    // end claimCapability
  }

  public function releaseCapability(capability:String,
                                    component:ComponentHandle<T>):Void
  {
    if (capabilities.get(capability) == component)
      capabilities.remove(capability);
    // end claimCapability
  }

  public function findCapability(capability:String):ComponentHandle<T>
  {
    return capabilities.get(capability);
    // end findCapability
  }

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function iterator():DoubleLinkedListIterator<ComponentHandle<T>>
  {
    return components.iterator();
  }

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function update(elapsed:Int):Void
  {

    // Update all entities

    var curr:DoubleLinkedListHandle<ComponentHandle<T>> = components.head;
    var next:DoubleLinkedListHandle<ComponentHandle<T>>;
    while (curr != null) {
      next = curr.next; // Cache this in case curr gets removed
                        // but it also means new entities won't
                        // get processed...

      curr.item.component.update(elapsed);
      curr = next;
    }

    // end update
  }


  // end ComponentContainer
}
