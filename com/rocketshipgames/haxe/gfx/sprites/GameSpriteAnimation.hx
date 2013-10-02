package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


class GameSpriteAnimation
{

  public static var DEFAULT_INTERVAL:Int = 100;

  public var label:String;
  public var loop:Bool;

  //----------------------------------------------------
  public var sequence(default,null):DoubleLinkedList<GameSpriteAnimationFrame>;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(label:String):Void
  {
    this.label = label;
    loop = false;
    sequence = new DoubleLinkedList();
    // end new
  }

  public function add(frame:Int, interval:Int):Void
  {
    sequence.add(new GameSpriteAnimationFrame(frame, interval));
    // end add
  }

  // end GameSpriteAnimation
}
