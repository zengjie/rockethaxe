package com.rocketshipgames.haxe.ds;

class Heap<T>
{
  private var array:Array<T>;
  private var cmp:T -> T -> Bool;

  public function new(comparator:T -> T -> Bool):Void
  {
    array = new Array();
    cmp = comparator;
  }

  public function _array():Array<T>
  {
    return array;
  }

  public inline function parent(i:Int):Int { return Std.int((i-1)/2); }
  public inline function left(i:Int):Int { return (i*2)+1; }
  public inline function right(i:Int):Int { return (i*2)+2; }


  /**
   * It is undefined what happens if the relevant trait of k, i.e.
   * whatever the comparator() function is looking at, is changed
   * while in the heap.  That can break the heap invariant and cause
   * untoward behavior.  Be warned!
   */
  public function add(k:T):Void
  {
    var newindex:Int = array.length;
    var parentindex:Int = parent(newindex);
    var tmp:T;

    array.push(k);

    while (newindex > 0 && cmp(k, array[parentindex])) {
      tmp = array[newindex];
      array[newindex] = array[parentindex];
      array[parentindex] = tmp;

      newindex = parentindex;
      parentindex = parent(newindex);
    }

    // end add
  }

  public function peek():T
  {
    return (array.length == 0) ? null : array[0];
    // end peek
  }

  public function remove(index:Int):T
  {
    var res:T;

    if (array.length <= 0 || index < 0 || index >= array.length)
      return null;

    if (array.length == 1)
      return array.pop();

    var res:T = array[index];
    array[index] = array.pop();

    if (left(index) < array.length) {
      var root:Int = index;
      var child:Int = left(root);
      var tmp:T;

      do {
        if (child < array.length - 1 &&
            cmp(array[child+1], array[child]))
          child++;

        if (cmp(array[root], array[child]))
          break;

        tmp = array[root];
        array[root] = array[child];
        array[child] = tmp;

        root = child;
        child = left(root);
      } while (child < array.length);
    }

    return res;
    // end remove
  }

  public function pop():T
  {
    return remove(0);
  }

  public function find(test:T->Bool):Int
  {
    var i:Int = 0;
    for (e in array) {
      if (test(e))
        break;
      i++;
    }

    if (i == array.length)
      return -1;

    return i;
    // end find
  }

  public function hasElements():Bool
  {
    return (array.length > 0);
  }

  // end Heap
}
