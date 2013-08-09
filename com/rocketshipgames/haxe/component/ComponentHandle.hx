package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


@:allow(com.rocketshipgames.haxe.component.ComponentContainer)
class ComponentHandle
{

  //--------------------------------------------------------------------
  public var container(default, null):ComponentContainer;
  public var component(default, null):Component;

  private var listHandle:DoubleLinkedListHandle<ComponentHandle>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(container:ComponentContainer,
                      component:Component):Void
  {
    this.container = container;
    this.component = component;
    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function remove():Void
  {
    container.removeComponent(this);
  }

  // end ComponentHandle
}
