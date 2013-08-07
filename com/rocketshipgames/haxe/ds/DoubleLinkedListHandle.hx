package com.rocketshipgames.haxe.ds;


@:allow(com.rocketshipgames.haxe.ds.DoubleLinkedList)
class DoubleLinkedListHandle<T>
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public var list(default,null):DoubleLinkedList<T>;

  public var next(default,null):DoubleLinkedListHandle<T>;
  public var prev(default,null):DoubleLinkedListHandle<T>;

  public var item(default,null):T;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(list:DoubleLinkedList<T>, item:T):Void
  {
    this.list = list;
    this.item = item;
    // end new
  }

  // end DoubleLinkedListHandle
}
