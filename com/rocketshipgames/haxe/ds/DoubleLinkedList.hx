package com.rocketshipgames.haxe.ds;

import com.rocketshipgames.haxe.debug.Debug;


class DoubleLinkedList<T>
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public var head(default,null):DoubleLinkedListHandle<T>;
  public var tail(default,null):DoubleLinkedListHandle<T>;

  public var count(default,null):Int;

  private var handlePool:Deadpool<DoubleLinkedListHandle<T>>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    handlePool = new Deadpool<DoubleLinkedListHandle<T>>(newHandle);
    // end new
  }

  private function newHandle(opts:Dynamic):DoubleLinkedListHandle<T>
  {
    return new DoubleLinkedListHandle<T>(opts.list, opts.item);
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function add(item:T):DoubleLinkedListHandle<T>
  {
    var handle = handlePool.newObject({list: this, item: item});

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

  //----------------------------------------------------
  public function insert(item:T):DoubleLinkedListHandle<T>
  {
    var handle = handlePool.newObject({list: this, item: item});

    if (tail == null)
      tail = handle;

    handle.next = head;
    head = handle;

    handle.prev = null;

    count++;

    return handle;
    // end add
  }

  //----------------------------------------------------
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

    handlePool.returnObject(handle);

    count--;
    // end remove
  }

  public function removeItem(item:T):Void
  {
    var i = head;
    while (i != null && i.item != item)
      i = i.next;

    if (i != null) {
      remove(i);
    }
    // end removeManual
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function iterator():DoubleLinkedListIterator<T>
  {
    return new DoubleLinkedListIterator<T>(head);
    // end iterator
  }

  // end DoubleLinkedList
}
