package com.rocketshipgames.haxe.ds;

import com.rocketshipgames.haxe.debug.Debug;


class DoubleLinkedList<T>
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public var head(default,null):DoubleLinkedListHandle<T>;
  public var tail(default,null):DoubleLinkedListHandle<T>;

  public var count(default,null):Int;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function add(item:T):DoubleLinkedListHandle<T>
  {
    var handle = new DoubleLinkedListHandle<T>(this, item);

    /*
    if (handle.prev != null || handle.next != null || head == handle) {
      Debug.error("Item already in list.");
      return item;
    }
    */

    if (tail == null)
      head = handle;
    else
      tail.next = handle;

    handle.prev = tail;
    tail = handle;
    handle.next = null;

    count++;

    return handle;
    // end add
  }

  public function remove(handle:DoubleLinkedListHandle<T>):Void
  {

    if ((handle.prev == null && head != handle) ||
        (handle.next == null && tail != handle)) {
      Debug.error("Item not in list.");
      return;
    }

    if (handle.prev != null)
      handle.prev.next = handle.next;
    else
      head = handle.next;

    if (handle.next != null)
      handle.next.prev = handle.prev;
    else
      tail = handle.prev;

    handle.prev = handle.next = null;
    handle.list = null;

    count--;
    // end remove
  }


  // end DoubleLinkedList
}
