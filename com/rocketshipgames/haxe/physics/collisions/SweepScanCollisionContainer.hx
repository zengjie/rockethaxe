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

import com.rocketshipgames.haxe.debug.Debug;

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
  private function newSweepEvent(type:SweepEventType,
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
  private function addToScanList(e:SweepEvent):Void
  {
    if (scanHead != null)
      scanHead.prev = e;

    e.next = scanHead;
    e.prev = null;

    scanHead = e;
    // end addToScanList
  }

  private function removeFromScanList(e:SweepEvent):Void
  {
    // If I'm not in the scan list, bail
    if (e.prev == null && e.next == null && scanHead != e)
      return;

    if (e.prev != null)
      e.prev.next = e.next;
    else
      scanHead = e.next;

    if (e.next != null)
      e.next.prev = e.prev;

    e.prev = null;
    e.next = null;
    // end removeFromScanList
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function collide():Void
  {
    var event:SweepEvent;

    var e:CollisionEntity = group.head;
    while (e != null) {
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

      outer = event.entity;

      switch (event.type) {
      case TOP:
        scanEvent = scanHead;
        while (scanEvent != null) {
          inner = scanEvent.entity;

          innerHit = (((outerAs=outer.collidesAs) & inner.collidesWith) != 0);
          outerHit = (((innerAs=inner.collidesAs) & outer.collidesWith) != 0);

          if ((innerHit || outerHit) &&
              !(outer.left() > inner.right() ||
                outer.right() < inner.left() ||
                outer.top() > inner.bottom() ||
                outer.bottom() < inner.top())) {

            if (innerHit)
              inner.collide(outerAs, outer);

            if (outerHit)
              outer.collide(innerAs, inner);

            // If the inner hit was removed, remove it from the scan list
            if (inner.nextCollisionEntity == null &&
                inner.prevCollisionEntity == null) {
              removeFromScanList(scanEvent);
            }

            // If the current entity was removed, bail.  This isn't
            // inside the outerHit check above in case the inner
            // collision actually removes the entity.
            if (outer.nextCollisionEntity == null &&
                outer.prevCollisionEntity == null) {
              break;
            }

            // end there was a hit
          }

          scanEvent = scanEvent.next;
          // end looping scan list
        }

        // If outer is still in the group, add to scan list.  Note
        // that this check works because if it's still in the group
        // but the pointers are null, there are no other entities to
        // compare against anyway...
        if (isInGroup(outer))
          addToScanList(event);


      case BOTTOM:
        scanEvent = event.next;
        removeFromScanList(scanEvent);

        event.next.next = deadpool;
        deadpool = event.next;

        event.next = deadpool;
        deadpool = event;
      }

      // end while events exist
    }

    if (scanHead != null) {
      Debug.error("SCAN LIST IS CORRUPTED.");
      #if cpp
        Sys.exit(-1);
      #end
    }
    if (heap.hasElements()) {
      Debug.error("HEAP IS CORRUPTED.");
      #if cpp
        Sys.exit(-1);
      #end
    }

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
