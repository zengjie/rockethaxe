package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.DoubleLinkedListIterator;

import com.rocketshipgames.haxe.util.Jenkins;


class ComponentContainer
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  private var components:DoubleLinkedList<ComponentHandle>;

  private var capabilities:Map<CapabilityID,ComponentHandle>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    components = new DoubleLinkedList();
    capabilities = new Map();
    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function hashID(id:String):CapabilityID
  {
    return Jenkins.hash32(id);
    // end hashID
  }

  public static function reverseID(id:CapabilityID):String
  {
    return Jenkins.reverse32(id);
    // end reverseID
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
  public function claimCapability(capability:CapabilityID,
                                  component:ComponentHandle):Void
  {
    capabilities.set(capability, component);
    // end claimCapability
  }

  public function releaseCapability(capability:CapabilityID,
                                    component:ComponentHandle):Void
  {
    if (capabilities.get(capability) == component)
      capabilities.remove(capability);
    // end claimCapability
  }

  public function findCapability(capability:CapabilityID,
                                 necessary:Bool=true):Component
  {
    var x = capabilities.get(capability);

    if (x != null)
      return x.component;

    if (necessary)
      Debug.error("Capability " + reverseID(capability) +
                  " (" + capability + ") not found.");

    return null;
    // end findCapability
  }

  public function findCapabilityHandle(capability:CapabilityID,
                                       necessary:Bool=true):ComponentHandle
  {
    var res = capabilities.get(capability);

    if (necessary && res == null)
      Debug.error("Capability " + reverseID(capability) +
                  " (" + capability + ") not found.");

    return res;
    // end findCapabilityHandle
  }

  //----------------------------------------------------
  public function claimCapabilityID(capability:String,
                                    component:ComponentHandle):Void
  {
    claimCapability(hashID(capability), component);
  }

  public function releaseCapabilityID(capability:String,
                                      component:ComponentHandle):Void
  {
    releaseCapability(hashID(capability), component);
  }

  public function findCapabilityID(capability:String,
                                   necessary:Bool=true):Component
  {
    return findCapability(hashID(capability), necessary);
  }

  public function findCapabilityHandleID(capability:String,
                                         necessary:Bool=true):ComponentHandle
  {
    return findCapabilityHandle(hashID(capability), necessary);
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
      next = curr.next; // Cache this in case curr gets removed but it
                        // also means new entities created by the last
                        // entity won't be processed this update...

      curr.item.component.update(elapsed);
      curr = next;
    }

    // end update
  }


  // end ComponentContainer
}
