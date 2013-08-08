package com.rocketshipgames.haxe.ds;


@:allow(com.rocketshipgames.haxe.ds.DoubleLinkedList)
class DoubleLinkedListHandle<T>
    implements DeadpoolObject
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
    #if verbose_ds
      trace("New DoubleLinkedListHandle");
    #end

    this.list = list;
    this.item = item;
    // end new
  }

  public function remove():Void
  {
    list.remove(this);
    // end remove
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function setDeadpool(deadpool:Dynamic):Void
  {
  }

  public function init(?opts:Array<Dynamic>):Void
  {
    list = opts[0];
    item = opts[1];
  }

  // end DoubleLinkedListHandle
}
