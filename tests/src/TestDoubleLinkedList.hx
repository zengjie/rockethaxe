package ;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;


class TestDoubleLinkedList
{

  public static function main():Void
  {

    trace("Test DoubleLinkedList");

    var list:DoubleLinkedList<Item> = new DoubleLinkedList();

    var i = 0;
    while (i < 10) {
      list.add(new Item(i));
      i++;
    }

    trace("Iterating, removing four (every third):");
    var curr = list.head;
    while (curr != null) {
      trace("Item " + curr.item.id);
      var next = curr.next;

      if (curr.item.id % 3 == 0)
        curr.remove();

      curr = next;
    }

    trace("Iterating again:");
    curr = list.head;
    while (curr != null) {
      trace("Item " + curr.item.id);
      curr = curr.next;
    }

    trace("Adding 5 more; iterating again:");
    while (i < 15) {
      list.add(new Item(i));
      i++;
    }

    for (x in list) {
      trace("Item " + x.id);
    }


    trace("Removing two and iterating again");
    list.head.remove();
    list.head.remove();

    for (x in list) {
      trace("Item " + x.id);
    }


    // end main
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
