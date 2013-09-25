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


    //------------------------------------------------------------------
    var fheap:Heap<FloatItem> = new Heap(lessFloat);

    fheap.add(new FloatItem(13.023987));
    fheap.add(new FloatItem(14.023987));
    fheap.add(new FloatItem(15.023987));
    fheap.add(new FloatItem(16.023987));

    // Since NaN compares false to everything, inserting NaN into a
    // float list will break everything.
    // fheap.add(new FloatItem(Math.NaN)); 

    fheap.add(new FloatItem(15.023987));
    fheap.add(new FloatItem(16.023987));
    fheap.add(new FloatItem(9.023987));
    fheap.add(new FloatItem(10.023987));
    fheap.add(new FloatItem(14.10988637));
    fheap.add(new FloatItem(15.10988637));
    fheap.add(new FloatItem(14.05891982));
    fheap.add(new FloatItem(15.05891982));
    fheap.add(new FloatItem(13.19578573));
    fheap.add(new FloatItem(14.19578573));
    fheap.add(new FloatItem(11.023987));
    fheap.add(new FloatItem(12.023987));
    fheap.add(new FloatItem(19.023987));
    fheap.add(new FloatItem(20.023987));
    fheap.add(new FloatItem(9.023987));
    fheap.add(new FloatItem(10.023987));
    fheap.add(new FloatItem(11.45631807));
    fheap.add(new FloatItem(12.45631807));

    var fprev:Float = -1;
    var fitem:FloatItem;
    while ((fitem = fheap.pop()) != null) {
      if (fitem.val < fprev) {
        trace("ERROR: Float heap not sorted");
        Sys.exit(1);
      }
      fprev = fitem.val;
    }
    trace("Float order confirmed");

    // end main
  }


  private static function less(a:Item, b:Item):Bool
  {
    return (a.id < b.id);
  }

  private static function lessFloat(a:FloatItem, b:FloatItem):Bool
  {
    return (a.val < b.val);
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


private class FloatItem
{

  public var val:Float;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(val:Float):Void
  {
    this.val = val;
    // end new
  }

  // end Item
}
