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

package com.rocketshipgames.haxe.ui.widgets;

import nme.display.DisplayObjectContainer;

import nme.display.Bitmap;
import nme.display.BitmapData;

import com.rocketshipgames.haxe.gfx.widgets.DecoratedBitmap;

import com.rocketshipgames.haxe.ui.widgets.Button;


class BitmapButton
  extends Button
{

  //------------------------------------------------------------
  private var bitmap:Bitmap;

  private var upBitmap:BitmapData;
  private var overBitmap:BitmapData;
  private var downBitmap:BitmapData;
  private var disabledBitmap:BitmapData;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(action:Void->Void,
                      upBitmap:BitmapData,
                      overBitmap:BitmapData = null,
                      downBitmap:BitmapData = null,
                      disabledBitmap:BitmapData = null,
                      ?container:DisplayObjectContainer):Void
  {
    super(action, container);

    this.upBitmap = upBitmap;
    this.overBitmap = (overBitmap != null) ? overBitmap : upBitmap;
    this.downBitmap = (downBitmap != null) ? downBitmap : upBitmap;

    if (disabledBitmap == null)
      generateDisabledBitmap();
    else
      this.disabledBitmap = disabledBitmap;

    addChild(bitmap = new Bitmap(upBitmap));
    // end new
  }

  private function generateDisabledBitmap():Void
  {
    disabledBitmap = DecoratedBitmap.makeBitmapData
      (upBitmap,
       {redMultiplier: 0.66,
        greenMultiplier: 0.66,
        blueMultiplier: 0.66,
       });
    // end generateDisabledBitmap
  }

  public function setBitmaps(up:BitmapData,
                             over:BitmapData,
                             down:BitmapData,
                             ?disabled:BitmapData):Void
  {
    upBitmap = up;
    overBitmap = over;
    downBitmap = down;

    if (disabled == null)
      generateDisabledBitmap();
    else
      disabledBitmap = disabled;

    updateGraphicState();
    // end setBitmaps
  }

  public function setBitmap(bmp:BitmapData):Void
  {
    upBitmap = overBitmap = downBitmap = disabledBitmap = bmp;
    updateGraphicState();
    // end setBitmap
  }

  public function setUpBitmap(bmp:BitmapData):Void
  {
    upBitmap = bmp;
    updateGraphicState();
    // end setUpBitmap
  }

  public function setOverBitmap(bmp:BitmapData):Void
  {
    overBitmap = bmp;
    updateGraphicState();
    // end setOverBitmap
  }

  public function setDownBitmap(bmp:BitmapData):Void
  {
    downBitmap = bmp;
    updateGraphicState();
    // end setDownBitmap
  }

  public function setDisabledBitmap(bmp:BitmapData):Void
  {
    disabledBitmap = bmp;
    updateGraphicState();
    // end setDownBitmap
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private override function updateGraphicState():Void
  {
    switch (state) {
    case UP:
      bitmap.bitmapData = upBitmap;

    case OVER:
      bitmap.bitmapData = overBitmap;

    case DOWN:
      bitmap.bitmapData = downBitmap;

    case DISABLED:
      bitmap.bitmapData = disabledBitmap;
    }
    // end updateGraphicState
  }

  // end BitmapButton
}
