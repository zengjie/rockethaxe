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

package com.rocketshipgames.haxe.text.widgets;

import nme.Assets;

import nme.display.DisplayObjectContainer;

import com.rocketshipgames.haxe.text.GameText;
import com.rocketshipgames.haxe.text.GameTextList;
import com.rocketshipgames.haxe.text.HorizontalJustification;
import com.rocketshipgames.haxe.text.VerticalJustification;

import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;


class LogGameTextList
  extends GameTextList
{

  //------------------------------------------------------------
  public var x:Float;
  public var y:Float;
  public var margin:Int;

  //------------------------------------------------------------
  private var height:Int;

  private var parent:DisplayObjectContainer;

  private var dirty:Bool;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(parent:DisplayObjectContainer)
  {
    super();
    this.parent = parent;
    x = 0;
    y = 0;
    height = 0;
    margin = 0;
    dirty = false;
    // end new
  }

  //------------------------------------------------------------
  public override function receiveText(text:String, opts:Dynamic=null):Void
  {
    super.receiveText(text, opts);

    height += Std.int(last.bitmap.height);

    // Have to explicitly update rather than mark dirty like in
    // remove() because the new one will become visible immediately
    // and needs to have a correct position set or it'll flash.
    updatePositions();

    parent.addChild(last.bitmap);
    // end receiveText
  }

  private override function remove(text:GameText)
  {
    height -= Std.int(text.bitmap.height);
    parent.removeChild(text.bitmap);
    dirty = true;
    super.remove(text);
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function updatePositions():Void
  {
    var dx:Float;
    var dy:Float = this.y;

    if (verticalJustification == BOTTOM)
      dy -= calcTrueHeight();
    else if (verticalJustification == MIDDLE)
      dy -= calcTrueHeight() / 2.0;

    for (lt in texts) {
        switch (horizontalJustification) {
        case LEFT:
          dx = this.x;
        case CENTER:
          dx = this.x - lt.bitmap.width/2;
        case RIGHT:
          dx = this.x - lt.bitmap.width;
        }

        lt.bitmap.x = dx;
        lt.bitmap.y = dy;

        /*
        matrix.identity();
        matrix.translate(dx, dy);
        graphics.beginBitmapFill(lt.bitmap, matrix);
        graphics.drawRect(dx, dy, lt.bitmap.width, lt.bitmap.height);
        graphics.endFill();
        */

        dy += lt.bitmap.height + margin;

      // end looping texts
    }

    dirty = false;
    // end updatePositions()
  }

  private function calcTrueHeight():Int
  {
    return height + ((texts.length-1)*margin);
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function render(graphics:nme.display.Graphics,
                                  elapsed:Int):Void
  {
    super.render(graphics, elapsed);
    if (dirty)
      updatePositions();
    // end render
  }

  // end LogGameTextList
}
