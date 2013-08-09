package com.rocketshipgames.haxe.component;


interface Component
{

  /*
  //--------------------------------------------------------------------
  //----------------------------------------------------
  @:allow(com.rocketshipgames.haxe.component.ComponentContainer)
    public var container(default, null):World;

  @:allow(com.rocketshipgames.haxe.component.ComponentContainer)
    private var next:Entity;
  @:allow(com.rocketshipgames.haxe.component.ComponentContainer)
    private var prev:Entity;

  public var id(default, null):String;
  */

  /*
  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(?id:String):Void
  {
    container = null;
    next = null;
    prev = null;
    this.id = id;
    // end new
  }
  */

  function attach(containerHandle:ComponentHandle):Void;
  function detach():Void;

  function update(elapsed:Int):Void;

  // end Component
}
