package ;

import com.rocketshipgames.haxe.ds.Heap;


class TestHeap
{

  public static function main():Void
  {

    trace("Test Heap");

    var heap:Heap<Item> = new Heap(less);


    trace("Adding 0...9");
    for (i in 0...10) {
      heap.add(new Item(i));
    }

    trace("Peek " + heap.peek().id);

    var item:Item;
    while ((item = heap.pop()) != null) {
      trace("Popped " + item.id);
    }


    trace("Adding 0...9, 0..9");
    for (i in 0...10) {
      heap.add(new Item(i));
    }
    for (i in 0...10) {
      heap.add(new Item(i));
    }

    var item:Item;
    while ((item = heap.pop()) != null) {
      trace("Popped " + item.id);
    }


    // Can't actually show the sequence below because I want to
    // compare against fixed previous output, and AFAIK ATM there's no
    // super straightforward mechanism in Haxe to seed the random
    // number generator.  - tjkopena

    trace("Adding random");
    for (i in 0...100) {
      heap.add(new Item(Std.random(512)));
    }

    var prev:Int = -1;
    var item:Item;
    while ((item = heap.pop()) != null) {
      if (item.id < prev) {
        trace("ERROR: Heap not sorted");
        Sys.exit(1);
      }
      prev = item.id;
    }
    trace("Order confirmed");




    trace("Adding and popping random");
    for (i in 0...100) {
      heap.add(new Item(Std.random(512)));
    }

    var prev:Int = -1;
    var item:Item;
    var i:Int = 0;
    while ((item = heap.pop()) != null && i < 30) {
      if (item.id < prev) {
        trace("ERROR: Heap not sorted");
        Sys.exit(1);
      }
      prev = item.id;
      i++;
    }
    trace("Order confirmed");

    for (i in 0...100) {
      heap.add(new Item(Std.random(512)));
    }

    var prev:Int = -1;
    var item:Item;
    i = 0;
    while ((item = heap.pop()) != null) {
      if (item.id < prev) {
        trace("ERROR: Heap not sorted");
        Sys.exit(1);
      }
      prev = item.id;
      i++;
    }
    trace("Order confirmed");

    // end main
  }


  private static function less(a:Item, b:Item):Bool
  {
    return (a.id < b.id);
  }

  // end TestDoubleLinkedList
}


private class Item
{

  public var id:Int;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(id:Int):Void
  {
    this.id = id;
    // end new
  }

  // end Item
}
