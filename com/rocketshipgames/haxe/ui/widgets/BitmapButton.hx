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

import com.rocketshipgames.haxe.ui.widgets.Button;


class BitmapButton
  extends Button
{

  private var bitmap:Bitmap;

  private var upBitmap:BitmapData;
  private var overBitmap:BitmapData;
  private var downBitmap:BitmapData;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObjectContainer,
                      action:Void->Void,
                      upBitmap:BitmapData,
                      overBitmap:BitmapData = null,
                      downBitmap:BitmapData = null):Void
  {
    super(container, action);

    this.upBitmap = upBitmap;
    this.overBitmap = (overBitmap != null) ? overBitmap : upBitmap;
    this.downBitmap = (downBitmap != null) ? downBitmap : upBitmap;

    addChild(bitmap = new Bitmap(upBitmap));
    // end new
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
    }
    // end updateGraphicState
  }

  // end BitmapButton
}
