/*
 * Copyright (c) 2012 Joe Kopena <tjkopena@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/

package com.rocketshipgames.haxe.physics.collisions;

import com.rocketshipgames.haxe.physics.CollisionEntity;

import com.rocketshipgames.haxe.ds.Heap;

class SweepScanCollisionContainer
  extends BaseCollisionContainer
{

  private var heap:Heap<SweepEvent>;
  private var scanHead:SweepEvent;
  private var deadpool:SweepEvent;

  //--------------------------------------------------------------------
  public function new():Void
  {
    super();
    heap = new Heap(topmost);
    scanHead = null;
    deadpool = null;
    // end new
  }

  private function topmost(a:SweepEvent, b:SweepEvent):Bool
  {
    return (a.y < b.y);
    // end topmost
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function newSweepEvent(type:SweepEventType,
                                y:Float,
                                entity:CollisionEntity,
                                next:SweepEvent,
                                prev:SweepEvent):SweepEvent
  {
    if (deadpool == null)
      return new SweepEvent(type, y, entity, next, prev);

    var d:SweepEvent = deadpool;
    deadpool = d.next;
    d.init(type, y, entity, next, prev);

    return d;
    // end newSweepEvent
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function collide():Void
  {
    var event:SweepEvent;

    var e:CollisionEntity = group.head;
    while (e != null) {
      //trace("Heap " + Type.getClassName(Type.getClass(e)) +
      //      " top " + e.top() + " bottom " + e.bottom());
      heap.add(event = newSweepEvent(TOP, e.top(), e, null, null));
      heap.add(newSweepEvent(BOTTOM, e.bottom(), e, event, null));

      e = e.nextCollisionEntity;
    }

    var scanEvent:SweepEvent;

    var outer:CollisionEntity;
    var inner:CollisionEntity;

    var innerHit:Bool;
    var outerHit:Bool;

    var innerAs:Int;
    var outerAs:Int;

    while ((event = heap.pop()) != null) {
      //trace("Pop " + event.type + " " + event.y + " " + event.entity);

      outer = event.entity;

      switch (event.type) {
      case TOP:
        scanEvent = scanHead;
        while (scanEvent != null) {
          inner = scanEvent.entity;

          //trace("Scan " + Type.getClassName(Type.getClass(inner)));

          innerHit = (((outerAs=outer.collidesAs) & inner.collidesWith) != 0);
          outerHit = (((innerAs=inner.collidesAs) & outer.collidesWith) != 0);

          if ((innerHit || outerHit) &&
              !(outer.left() > inner.right() ||
                outer.right() < inner.left() ||
                outer.top() > inner.bottom() ||
                outer.bottom() < inner.top())) {

            //trace("Collide " + Type.getClassName(Type.getClass(outer)) + "  " +
            //      Type.getClassName(Type.getClass(inner)));

            if (innerHit)
              inner.collide(outerAs, outer);

            if (outerHit)
              outer.collide(innerAs, inner);
          }

          scanEvent = scanEvent.next;
          // end looping scan list
        }

        if (scanHead != null)
          scanHead.prev = event;
        event.next = scanHead;
        event.prev = null;
        scanHead = event;


      case BOTTOM:
        scanEvent = event.next;
        if (scanEvent.prev != null)
          scanEvent.prev.next = scanEvent.next;
        else
          scanHead = scanEvent.next;

        if (scanEvent.next != null)
          scanEvent.next.prev = scanEvent.prev;

        event.next.next = deadpool;
        deadpool = event.next;

        event.next = deadpool;
        deadpool = event;
      }

      // end while events exist
    }

    /*
    if (scanHead != null) {
      trace("SCAN LIST IS CORRUPTED");
      Sys.exit(-1);
    }
    if (heap.hasElements()) {
      trace("HEAP IS CORRUPTED");
      Sys.exit(-1);
    }
    */

    /*
    if (heap.hasElements() || scan.length > 0) {
      trace("Heap " + ((heap.hasElements())?"populated":"empty") +
            "; scan " + ((scan.length > 0)?"populated":"empty"));
      //Sys.exit(-1);
    }
    */

    // end collide
  }

  // end SweepScanCollisionContainer
}

enum SweepEventType {
  TOP;
  BOTTOM;
}

private class SweepEvent
{
  public var type:SweepEventType;
  public var y:Float;
  public var entity:CollisionEntity;

  public var next:SweepEvent;
  public var prev:SweepEvent;

  public function new(type:SweepEventType,
                      y:Float,
                      entity:CollisionEntity,
                      next:SweepEvent,
                      prev:SweepEvent):Void
  {
    this.type = type;
    this.y = y;
    this.entity = entity;
    this.next = next;
    this.prev = prev;
    // end new
  }

  public function init(type:SweepEventType,
                       y:Float,
                       entity:CollisionEntity,
                       next:SweepEvent,
                       prev:SweepEvent):Void
  {
    this.type = type;
    this.y = y;
    this.entity = entity;
    this.next = next;
    this.prev = prev;
    // end init
  }

  // end SweepEvent
}
