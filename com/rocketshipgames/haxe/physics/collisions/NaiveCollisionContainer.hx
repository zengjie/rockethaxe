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

class NaiveCollisionContainer
  implements CollisionContainer
{
  private var group:List<CollisionEntity>;

  //--------------------------------------------------------------------
  public function new():Void
  {
    group = new List();
    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addEntity(e:CollisionEntity):Void
  {
    group.add(e);
    // end add
  }

  public function removeEntity(e:CollisionEntity):Void
  {
    group.remove(e);
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function collide():Void
  {

    var outerHit:Bool;
    var innerAs:Int;

    for (outer in group) {
      for (inner in group) {

        if (outer != inner) {

          // innerHit = (((outerAs=outer.collidesAs) & inner.collidesWith) != 0);
          outerHit = (((innerAs=inner.collidesAs) & outer.collidesWith) != 0);

          if (outerHit /*(innerHit || outerHit) */ &&

              !(outer.left() > inner.right() ||
                outer.right() < inner.left() ||
                outer.top() > inner.bottom() ||
                outer.bottom() < inner.top())) {

            // The hit classes are checked twice (above and below) to
            // skip the geometric accesses and compares if not needed.

            // Note that the results have to be cached (in innerHit
            // and outerHit) in case the effects of inner.collide()
            // includes changing its hit class, which would cause
            // outer to not collide.  In general, inner shouldn't
            // change any properties that would be used by outer in
            // resolving its collision immediately thereafter.
            // Further, neither should remove itself from the
            // collision group immediately as then the other won't
            // receive the collision.

            /*
            // Commented out:
            // However, if one of them doesn't remove itself from the
            // collission group or make itself intangible immediately,
            // they will collide again a second time.
            */

            /*
            if (innerHit)
              inner.collide(outerAs, outer);
            */

            //if (outerHit)
            outer.collide(innerAs, inner);

            // end collision
          }

          // outer and inner are not the same objects
        }

        // end looping inner
      }
      // end looping outer
    }

    // end collide
  }

  // end NaiveCollisionContainer
}
