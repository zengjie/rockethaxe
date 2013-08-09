package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


@:allow(com.rocketshipgames.haxe.component.ComponentContainer)
class ComponentHandle<T:Component>
{

  //--------------------------------------------------------------------
  public var container(default, null):ComponentContainer<T>;
  public var component(default, null):T;

  private var listHandle:DoubleLinkedListHandle<ComponentHandle<T>>;
  

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(container:ComponentContainer<T>,
                      component:T):Void
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
