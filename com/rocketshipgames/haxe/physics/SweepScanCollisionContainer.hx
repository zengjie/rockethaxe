package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;


class SweepScanCollisionContainer
  implements Component
{

  private var SweepScanBroadphase<>

  private var group:DoubleLinkedList<RigidBody2DComponent>;
  private var heap:Heap<SweepEvent>;
  private var sweepPool:Deadpool<SweepEvent>;

  private var scanList:DoubleLinkedList<SweepEvent>;


  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new DoubleLinkedList();
    heap = new Heap(topmost);
    sweepPool = new Deadpool(newSweepEvent);
    scanList = new DoubleLinkedList();
    // end new
  }

  private function newSweepEvent(opts:Dynamic):SweepEvent
  {
    return new SweepEvent(opts);
  }

  private function topmost(a:SweepEvent, b:SweepEvent):Bool
  {
    return (a.y < b.y);
    // end topmost
  }

  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {

    /**
     * For each body in the group, add a top and bottom event to the
     * heap.  The top event adds the body to the scan list.  The
     * bottom event removes it.
     */

    // Manually iterating to avoid new iterator object creation
    var curr:DoubleLinkedListHandle<RigidBody2DComponent> = group.head;
    var next:DoubleLinkedListHandle<RigidBody2DComponent>;
    var body:RigidBody2DComponent;

    while (curr != null) {
      next = curr.next;
      body = curr.item;

      var top = sweepPool.newObject({type: TOP,
                                     y: body.top(),
                                     body: body,
                                     topEvent: null});
      var bottom = sweepPool.newObject({type: BOTTOM,
                                     y: body.bottom(),
                                     body: body,
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
    var event:SweepEvent;
    var scanEvent:DoubleLinkedListHandle<SweepEvent>;

    var outer:RigidBody2DComponent;
    var inner:RigidBody2DComponent;

    var innerHit:Bool;
    var outerHit:Bool;

    var innerAs:Int;
    var outerAs:Int;

    var distance:Float;
    var coverage:Float;

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


          // Check if this collision types can actually collide
          innerHit = (((outerAs=outer.collidesAs) & inner.collidesWith) != 0);
          outerHit = (((innerAs=inner.collidesAs) & outer.collidesWith) != 0);


          if (innerHit || outerHit) {

            if (outer.type == RIGID_CIRCLE &&
                inner.type == RIGID_CIRCLE) {

              var normX = (outer.position.x - inner.position.x);
              var normY = (outer.position.y - inner.position.y);

              var distSqr = (normX * normX) + (normY * normY);
              var radius = outer.radius + inner.radius;

              if (distSqr < radius * radius) {
                var dist = Math.sqrt(distSqr);
                var penetration = radius - distance;
                normX /= dist;
                normY /= dist;








              } else {
                // They did not actually hit
                innerHit = outerHit = false;
              }

              // end they're both circles
            }

                /*
              !(outer.left() > inner.right() ||
                outer.right() < inner.left() ||
                outer.top() > inner.bottom() ||
                outer.bottom() < inner.top())) {
                */

            if (innerHit || outerHit) {

            }

            if (innerHit)
              trace("Inner collision");
              //inner.collide(outerAs, outer);

            if (outerHit)
              trace("Outer collision");
                // outer.collide(innerAs, inner);

            // end collision types can collide
          }

          scanEvent = scanEvent.next;
          // end looping over scan list
        }

        // 2) Add current object to scan list
        event.scanHandle = scanList.add(event);


      case BOTTOM:
        // Bottom of an object.  Remove associated top from scan list
        event.topEvent.scanHandle.remove();

        // Return both the top and bottom SweepEvents to the deadpool
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


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer):Void
  {
    var body = cast(entity.find(RigidBody2DComponent.CID),
                    RigidBody2DComponent);
    group.add(body);

    // Create a sweep scan component and add to entity.
    // Component holds the group list handle, removes on deactive()

    // end add
  }

  // end SweepScanCollisionContainer
}


enum SweepEventType {
  TOP;
  BOTTOM;
}

private class SweepEvent
  implements DeadpoolObject
{
  public var type:SweepEventType;
  public var y:Float;
  public var body:RigidBody2DComponent;
  public var topEvent:SweepEvent;

  public var deadpool:Dynamic;

  public var scanHandle:DoubleLinkedListHandle<SweepEvent>;


  public function new(opts:Dynamic):Void
  {
    trace("New SweepEvent");
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

  // end SweepEvent
}
