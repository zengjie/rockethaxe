package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


@:allow(com.rocketshipgames.haxe.component.ComponentContainer)
class ComponentHandle
{

  //--------------------------------------------------------------------
  public var container(default, null):ComponentContainer;
  public var component(default, null):Component;

  private var listHandle:DoubleLinkedListHandle<ComponentHandle>;
  
  private var capabilities:DoubleLinkedList<CapabilityID>;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(container:ComponentContainer,
                      component:Component):Void
  {
    this.container = container;
    this.component = component;

    capabilities = new DoubleLinkedList();
    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function remove():Void
  {
    for (c in capabilities) {
      releaseCapability(c);
    }
    container.removeComponent(this);
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function claimCapability(capability:CapabilityID):Void
  {
    capabilities.add(capability);
    container.claimCapability(capability, this);
    // end claimCapability
  }

  public function releaseCapability(capability:CapabilityID):Void
  {
    capabilities.removeItem(capability);
    container.releaseCapability(capability, this);
    // end releaseCapability
  }

  public function findCapability(capability:CapabilityID,
                                 necessary:Bool=true):Component
  {
    return container.findCapability(capability, necessary);
    // end findCapability
  }

  public function findCapabilityHandle(capability:CapabilityID,
                                       necessary:Bool=true):ComponentHandle
  {
    return container.findCapabilityHandle(capability, necessary);
    // end findCapabilityHandle
  }

  //----------------------------------------------------
  public function claimCapabilityID(capability:String):Void
  {
    claimCapability(ComponentContainer.hashID(capability));
  }

  public function releaseCapabilityID(capability:String):Void
  {
    releaseCapability(ComponentContainer.hashID(capability));
  }

  public function findCapabilityID(capability:String,
                                   necessary:Bool=true):Component
  {
    return findCapability(ComponentContainer.hashID(capability),
                          necessary);
  }

  public function findCapabilityHandleID(capability:String,
                                         necessary:Bool=true):ComponentHandle
  {
    return findCapabilityHandle(ComponentContainer.hashID(capability),
                                necessary);
  }


  // end ComponentHandle
}
