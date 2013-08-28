package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


@:allow(com.rocketshipgames.haxe.component.ComponentContainer)
class ComponentHandle
{

  //--------------------------------------------------------------------
  public var container(default, null):ComponentContainer;
  public var component(default, null):Component;

  public var signals(get_signals,null):SignalDispatcher;
  public var states(get_states,null):StateKeeper;
  public var events(get_events,null):Scheduler;

  //--------------------------------------------------------------------
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

  //----------------------------------------------------
  public function get_signals():SignalDispatcher
  {
    return container.get_signals();
    // end get_signals
  }

  public function get_states():StateKeeper
  {
    return container.get_states();
    // end get_states
  }

  public function get_events():Scheduler
  {
    return container.get_events();
    // end get_events
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function remove():Void
  {
    for (c in capabilities) {
      release(c);
    }
    container.remove(this);
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function claim(capability:CapabilityID):Void
  {
    capabilities.add(capability);
    container.claim(capability, this);
    // end claim
  }

  public function release(capability:CapabilityID):Void
  {
    capabilities.removeItem(capability);
    container.release(capability, this);
    // end release
  }

  public function find(capability:CapabilityID,
                       necessary:Bool=true):Component
  {
    return container.find(capability, necessary);
    // end find
  }

  public function findHandle(capability:CapabilityID,
                             necessary:Bool=true):ComponentHandle
  {
    return container.findHandle(capability, necessary);
    // end findHandle
  }

  //----------------------------------------------------
  public function claimByID(capability:String):Void
  {
    claim(ComponentContainer.hashID(capability));
  }

  public function releaseByID(capability:String):Void
  {
    release(ComponentContainer.hashID(capability));
  }

  public function findByID(capability:String,
                           necessary:Bool=true):Component
  {
    return find(ComponentContainer.hashID(capability), necessary);
  }

  public function findHandleByID(capability:String,
                                 necessary:Bool=true):ComponentHandle
  {
    return findHandle(ComponentContainer.hashID(capability), necessary);
  }


  // end ComponentHandle
}
