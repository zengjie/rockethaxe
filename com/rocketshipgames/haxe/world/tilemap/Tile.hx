package com.rocketshipgames.haxe.world.tilemap;


class Tile {

  public var label(default,null):String;

  public var frame(default,null):Int;
  public var collidesAs(default,null):Int;

  //--------------------------------------------------------------------
  public function new(frame:Int, collidesAs:Int, ?label:String):Void
  {
    this.frame = frame;
    this.collidesAs = collidesAs;
    this.label = label;
  }

  // end Tile
}
