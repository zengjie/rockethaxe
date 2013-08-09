package com.rocketshipgames.haxe.ds;

class DoubleLinkedListIterator<T>
//  implements Iterator<T>
{

  private var ptr:DoubleLinkedListHandle<T>;

  public function new(head:DoubleLinkedListHandle<T>):Void
  {
    ptr = head;
  }

  public function hasNext():Bool
  {
    return (ptr != null);
  }


  public function next():T
  {
    var prev = ptr;
    ptr = ptr.next;
    return prev.item;
  }

  // end DoubleLinkedListIterator
}
