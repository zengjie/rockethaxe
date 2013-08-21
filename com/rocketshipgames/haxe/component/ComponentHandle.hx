package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


@:allow(com.rocketshipgames.haxe.component.ComponentContainer)
class ComponentHandle<T:Component>
{

  //--------------------------------------------------------------------
  public var container(default, null):ComponentContainer<T>;
  public var component(default, null):T;

  private var listHandle:DoubleLinkedListHandle<ComponentHandle<T>>;
  
  private var capabilities:DoubleLinkedList<String>;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(container:ComponentContainer<T>,
                      component:T):Void
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

  // end ComponentHandle
}
