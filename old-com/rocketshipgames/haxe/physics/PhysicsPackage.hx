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

package com.rocketshipgames.haxe.physics;

class PhysicsPackage {
  public var xvel:Float;
  public var xacc:Float;
  public var xdrag:Float;

  public var yvel:Float;
  public var yacc:Float;
  public var ydrag:Float;

  public var xvelMin:Float;
  public var xvelMax:Float;

  public var yvelMin:Float;
  public var yvelMax:Float;

  public var mass:Float;

  private var parent:PhysicalEntity;

  public function new(parent:PhysicalEntity):Void
  {
    this.parent = parent;

    xvel = xacc = xdrag = 0;
    yvel = yacc = ydrag = 0;

    xvelMin = xvelMax = 0;
    yvelMin = yvelMax = 0;

    mass = 0;
    // end new
  }

  public function getParent():PhysicalEntity { return parent; }

  public function update(millis:Int):Void
  {
    // end update
  }

  // end PhysicsPackage
}
