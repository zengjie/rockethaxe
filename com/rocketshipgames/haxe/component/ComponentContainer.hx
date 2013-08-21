package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.DoubleLinkedListIterator;


class ComponentContainer
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  private var components:DoubleLinkedList<ComponentHandle>;

  private var capabilities:Map<String,ComponentHandle>;

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
  public function addComponent(component:Component):ComponentHandle
  {
    var containerHandle = new ComponentHandle(this, component);

    var listHandle = components.add(containerHandle);
    containerHandle.listHandle = listHandle;

    component.attach(containerHandle);

    return containerHandle;
    // end addComponent
  }

  public function removeComponent(handle:ComponentHandle):Void
  {
    components.remove(handle.listHandle);
    handle.component.detach();
    // end removeComponent
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function claimCapability(capability:String,
                                  component:ComponentHandle):Void
  {
    capabilities.set(capability, component);
    // end claimCapability
  }

  public function releaseCapability(capability:String,
                                    component:ComponentHandle):Void
  {
    if (capabilities.get(capability) == component)
      capabilities.remove(capability);
    // end claimCapability
  }

  public function findCapability(capability:String):ComponentHandle
  {
    return capabilities.get(capability);
    // end findCapability
  }

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function iterator():DoubleLinkedListIterator<ComponentHandle>
  {
    return components.iterator();
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function update(elapsed:Int):Void
  {

    // Update all entities

    var curr:DoubleLinkedListHandle<ComponentHandle> = components.head;
    var next:DoubleLinkedListHandle<ComponentHandle>;
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
