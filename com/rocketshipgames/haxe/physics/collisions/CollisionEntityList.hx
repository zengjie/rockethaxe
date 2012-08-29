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

/*
 * This class exists rather than incorporating directly into the
 * various collision containers so that the code is shared across
 * them, and to help future collision containers that maintain
 * multiple lists, e.g., divided by collision classes.
 */

package com.rocketshipgames.haxe.physics.collisions;

import com.rocketshipgames.haxe.debug.Debug;

class CollisionEntityList
{
  public var head:CollisionEntity;
  public var tail:CollisionEntity;

  public function new():Void
  {
    head = null;
    tail = null;
    // end new
  }

  public function add(i:CollisionEntity):Void
  {
    if (i.prevCollisionEntity != null || i.nextCollisionEntity != null) {
      Debug.error("CollisionEntity already in group.");
      return;
    }

    if (tail == null)
      head = i;
    else
      tail.nextCollisionEntity = i;

    i.prevCollisionEntity = tail;
    tail = i;
    i.nextCollisionEntity = null;

    // end add
  }

  public function remove(i:CollisionEntity):Void
  {
    if ((i.prevCollisionEntity == null && head != i) ||
        (i.nextCollisionEntity == null && tail != i)) {
      Debug.error("CollisionEntity not in group.");
      return;
    }

    if (i.prevCollisionEntity != null)
      i.prevCollisionEntity.nextCollisionEntity =
        i.nextCollisionEntity;
    else
      head = i.nextCollisionEntity;

    if (i.nextCollisionEntity != null)
      i.nextCollisionEntity.prevCollisionEntity =
        i.prevCollisionEntity;
    else
      tail = i.prevCollisionEntity;

    i.prevCollisionEntity = i.nextCollisionEntity  = null;

    // end remove
  }

  public function isInGroup(i:CollisionEntity):Bool
  {
    return (i.nextCollisionEntity != null ||
            i.prevCollisionEntity != null ||
            head == i);
    // end isInGroup
  }

  // end CollisionEntityList
}
