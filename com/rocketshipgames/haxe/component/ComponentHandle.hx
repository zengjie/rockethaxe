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
  
  private var capabilities:DoubleLinkedList<String>;

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
  public function claimCapability(capability:String):Void
  {
    #if verbose_cmp
      trace("Claiming capability " + capability);
    #end
      capabilities.add(capability);
    container.claimCapability(capability, this);
    // end claimCapability
  }

  public function releaseCapability(capability:String):Void
  {
    #if verbose_cmp
      trace("Releasing capability " + capability);
    #end
    capabilities.removeItem(capability);
    container.releaseCapability(capability, this);
    // end releaseCapability
  }

  public function findCapability(capability:String):ComponentHandle
  {
    return container.findCapability(capability);
    // end findCapability
  }

  // end ComponentHandle
}
