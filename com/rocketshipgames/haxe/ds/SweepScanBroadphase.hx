package com.rocketshipgames.haxe.ds;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.ds.Deadpool;
import com.rocketshipgames.haxe.ds.DeadpoolObject;
import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.Heap;


class SweepScanBroadphase<T:SweepScanEntity<D>, D>
{

  private var heap:Heap<SweepScanEvent<T,D>>;
  private var sweepPool:Deadpool<SweepScanEvent<T,D>>;

  private var scanList:DoubleLinkedList<SweepScanEvent<T,D>>;

  private var resolveEvent:T->T->Void;

  private var comparator:D->D->Bool;


  //--------------------------------------------------------------------
  public function new(comparator:D->D->Bool, resolveEvent:T->T->Void):Void
  {
    this.comparator = comparator;

    heap = new Heap(precedes);
    sweepPool = new Deadpool(newSweepScanEvent);
    scanList = new DoubleLinkedList();

    this.resolveEvent = resolveEvent;
    // end new
  }

  private function newSweepScanEvent(opts:Dynamic):SweepScanEvent<T,D>
  {
    return new SweepScanEvent<T,D>(opts);
  }

  /*
   * Note that you need the t member and a comparison over that rather than
   * comparing directly over the datas in case the 
   */
  private function precedes(a:SweepScanEvent<T,D>, b:SweepScanEvent<T,D>):Bool
  {
    return comparator(a.t, b.t);
    // end topmost
  }


  //------------------------------------------------------------------

  public function scan(group:DoubleLinkedList<T>):Void
  {

    /**
     * For each body in the group, add a top and bottom event to the
     * heap.  The top event adds the body to the scan list.  The
     * bottom event removes it.
     */

    // Manually iterating to avoid new iterator object creation
    var curr:DoubleLinkedListHandle<T> = group.head;
    var next:DoubleLinkedListHandle<T>;
    var outer:T;

    while (curr != null) {
      next = curr.next;
      outer = curr.item;

      var begin = sweepPool.newObject({    action: BEGIN,
                                                t: outer.begin(),
                                             data: outer,
                                       beginEvent: null});

      var end = sweepPool.newObject({    action: END,
                                              t: outer.end(),
                                           data: outer,
                                     beginEvent: begin});
      heap.add(begin);
      heap.add(end);

      curr = next;
      // end looping voer bodies
    }


    /**
     * For each event in the heap:
     *   - If it's a top, collide against scan list and add to the scan list
     *   - If it's a bottom, remove from the scan list
     */
    var event:SweepScanEvent<T,D>;
    var scanEvent:DoubleLinkedListHandle<SweepScanEvent<T,D>>;

    var inner:T;

    while ((event = heap.pop()) != null) {
      outer = event.data;

      switch (event.action) {
      case BEGIN:

        /**
         *  Encountered top of object
         *    1) Compare against list of active objects
         *    2) Add to list of active objects
         */

        // 1) Scan list of live entries
        scanEvent = scanList.head;
        while (scanEvent != null) {
          resolveEvent(outer, scanEvent.item.data);

          scanEvent = scanEvent.next;
          // end looping over scan list
        }

        // 2) Add current object to scan list
        event.scanHandle = scanList.add(event);


      case END:
        // Bottom of an object.  Remove associated top from scan list
        event.beginEvent.scanHandle.remove();

        // Return both the top and bottom SweepScanEvents to the deadpool
        event.beginEvent.repool();
        event.repool();
      }

      // end while heap is not null
    }

    #if debug
      if (scanList.head != null) {
        Debug.error("Scan list is not empty!");
      }
    #end

    // end update
  }

  // end SweepScanBroadphase
}


enum SweepScanEventAction {
  BEGIN;
  END;
}

private class SweepScanEvent<T,D>
  implements DeadpoolObject
{
  public var action:SweepScanEventAction;
  public var t:D;
  public var data:T;
  public var beginEvent:SweepScanEvent<T,D>;

  public var scanHandle:DoubleLinkedListHandle<SweepScanEvent<T,D>>;

  public var deadpool:Dynamic;


  public function new(opts:Dynamic):Void
  {
    #if verbose_ds
      trace("New SweepScanEvent");
    #end

    scanHandle = null;
    init(opts);
    // end new
  }

  public function init(?opts:Dynamic):Void
  {
    this.action = opts.action;
    this.t = opts.t;
    this.data = opts.data;
    this.beginEvent = opts.beginEvent;
    // end init
  }

  public function setDeadpool(deadpool:Dynamic):Void
  {
    this.deadpool = deadpool;
  }

  public function repool():Void
  {
    deadpool.returnObject(this);
  }

  // end SweepScanEvent
}
