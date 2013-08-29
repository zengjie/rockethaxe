package com.rocketshipgames.haxe.ds;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.ds.Deadpool;
import com.rocketshipgames.haxe.ds.DeadpoolObject;
import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.Heap;


class SweepScanBroadphase<T:SweepScanEntity,R>
{

  private var heap:Heap<SweepScanEvent<T>>;
  private var sweepPool:Deadpool<SweepScanEvent<T>>;

  private var scanList:DoubleLinkedList<SweepScanEvent<T>>;

  private var checkCollision:T->T->R;
  private var resolveCollision:R->Void;

  //--------------------------------------------------------------------
  public function new(checkCollision:T->T->R,resolveCollision:R->Void):Void
  {
    heap = new Heap(topmost);
    sweepPool = new Deadpool(newSweepScanEvent);
    scanList = new DoubleLinkedList();

    this.checkCollision = checkCollision;
    this.resolveCollision = resolveCollision;
    // end new
  }

  private function newSweepScanEvent(opts:Dynamic):SweepScanEvent<T>
  {
    return new SweepScanEvent<T>(opts);
  }

  private function topmost(a:SweepScanEvent<T>, b:SweepScanEvent<T>):Bool
  {
    return (a.y < b.y);
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

      var top = sweepPool.newObject({    type: TOP,
                                            y: outer.top(),
                                         body: outer,
                                     topEvent: null});

      var bottom = sweepPool.newObject({ type: BOTTOM,
                                            y: outer.bottom(),
                                         body: outer,
                                     topEvent: top});
      heap.add(top);
      heap.add(bottom);

      curr = next;
      // end looping voer bodies
    }


    /**
     * For each event in the heap:
     *   - If it's a top, collide against scan list and add to the scan list
     *   - If it's a bottom, remove from the scan list
     */
    var event:SweepScanEvent<T>;
    var scanEvent:DoubleLinkedListHandle<SweepScanEvent<T>>;

    var inner:T;

    var innerHit:Bool;
    var outerHit:Bool;

    var res:R;

    while ((event = heap.pop()) != null) {
      outer = event.body;

      switch (event.type) {
      case TOP:

        /**
         *  Encountered top of object
         *    1) Compare against list of active objects
         *    2) Add to list of active objects
         */

        // 1) Scan list of live entries
        scanEvent = scanList.head;
        while (scanEvent != null) {
          inner = scanEvent.item.body;

          // 1a) Check if this collision types can actually collide
          innerHit = ((outer.collidesAs() & inner.collidesWith()) != 0);
          outerHit = ((inner.collidesAs() & outer.collidesWith()) != 0);

          // 1b) Check if objects collide (narrowphase) and resolve if so
          if ((innerHit || outerHit) &&
              (res = checkCollision(outer, inner)) != null) {
            resolveCollision(res);
          }

          scanEvent = scanEvent.next;
          // end looping over scan list
        }

        // 2) Add current object to scan list
        event.scanHandle = scanList.add(event);


      case BOTTOM:
        // Bottom of an object.  Remove associated top from scan list
        event.topEvent.scanHandle.remove();

        // Return both the top and bottom SweepScanEvents to the deadpool
        event.topEvent.repool();
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


enum SweepScanEventType {
  TOP;
  BOTTOM;
}

private class SweepScanEvent<T>
  implements DeadpoolObject
{
  public var type:SweepScanEventType;
  public var y:Float;
  public var body:T;
  public var topEvent:SweepScanEvent<T>;

  public var scanHandle:DoubleLinkedListHandle<SweepScanEvent<T>>;

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
    this.type = opts.type;
    this.y = opts.y;
    this.body = opts.body;
    this.topEvent = opts.topEvent;
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
