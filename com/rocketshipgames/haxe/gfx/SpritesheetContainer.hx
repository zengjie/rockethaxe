/*
 * Copyright (c) 2013 Joe Kopena <tjkopena@gmail.com>
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

package com.rocketshipgames.haxe.gfx;

import nme.geom.Rectangle;
import nme.geom.Point;

import nme.display.BitmapData;
import nme.display.Tilesheet;

import com.rocketshipgames.haxe.debug.Debug;


class SpritesheetContainer 
  extends Tilesheet,
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer
{

  //--------------------------------------------------------------------
  private var blitData:Array<Float>;

  private var renderIndex:Int;

  private var renderers:Array<SpritesheetRenderer>;

  private var tileCount:Int;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(spritesheet:BitmapData):Void
  {
    if (spritesheet == null) {
      Debug.error("SpritesheetContainer must be given spritesheet BitmapData.");
      return;
    }

    super(spritesheet);

    blitData = new Array();

    renderers = new Array();

    tileCount = 0;

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addRenderer(r:SpritesheetRenderer):Void
  {
    renderers.push(r);
    // end addRenderer
  }

  //------------------------------------------------------------
  public function addSprite(x:Float, y:Float,
                            width:Float, height:Float,
                            cx:Float, cy:Float):Int
  {
    addTileRect(new Rectangle(x, y, width, height),
                new Point(cx, cy));
    tileCount++;
    return tileCount-1;
    // end addSprite
  }

  //------------------------------------------------------------
  public function getNumTiles():Int
  {
    return tileCount;
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function drawSprite(x:Float, y:Float, frame:Int):Void
  {

    if (renderIndex >= blitData.length) {
      blitData.push(x);
      blitData.push(y);
      blitData.push(frame);
    } else {
      blitData[renderIndex] = x;
      blitData[renderIndex+1] = y;
      blitData[renderIndex+2] = frame;
    }

    renderIndex += 3;

    // end drawSprite
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function render(graphics:nme.display.Graphics, elapsed:Int):Void
  {

    renderIndex = 0;
    for (r in renderers) {
      r.render(elapsed);
    }

    if (renderIndex < blitData.length) {
      blitData.splice(renderIndex, blitData.length-renderIndex);
    }

    drawTiles(graphics, blitData);

    // end render
  }

  // end SpritesheetContainer
}
