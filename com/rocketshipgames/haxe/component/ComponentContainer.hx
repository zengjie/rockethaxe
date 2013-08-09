package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.DoubleLinkedListIterator;


class ComponentContainer
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  private var components:DoubleLinkedList<ComponentHandle>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    components = new DoubleLinkedList();
    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function addComponent(component:Component):ComponentHandle
  {
    var containerFacade = new ComponentHandle
      (this, component);

    var listHandle = components.add(containerFacade);
    containerFacade.listHandle = listHandle;

    component.attach(containerFacade);

    return containerFacade;
    // end addComponent
  }

  public function removeComponent(facade:ComponentHandle):Void
  {
    components.remove(facade.listHandle);
    facade.component.detach();
    // end removeComponent
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
