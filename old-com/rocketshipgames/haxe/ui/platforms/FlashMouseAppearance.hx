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

package com.rocketshipgames.haxe.ui.platforms;

import nme.Assets;

import flash.Vector;

import nme.geom.Point;

import nme.display.Bitmap;
import nme.display.BitmapData;

import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;

import com.rocketshipgames.haxe.ui.Mouse;

class FlashMouseAppearance
  implements MouseAppearanceWrapper
{

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function enable(?cursor:String, ?hotspotX:Float, ?hotspotY:Float):Void
  {
    setCursor(cursor, hotspotX, hotspotY);
    // end enable
  }

  public function disable():Void
  {
    nme.ui.Mouse.cursor = MouseCursor.AUTO;
    nme.ui.Mouse.hide();
    // end disable
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function updateVisibility(visibility:Bool):Void
  {
    if (visibility)
      nme.ui.Mouse.show();
    else
      nme.ui.Mouse.hide();
    // end updateVisibility
  }

  //------------------------------------------------------------
  public function updatePosition(x:Float, y:Float):Void
  {
    // end updatePosition
  }

  //------------------------------------------------------------
  public function idleOut():Void
  {
    nme.ui.Mouse.hide();
    // end idleOut
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function setCursor(?asset:String=null,
                            ?hotspotX:Float=0, ?hotspotY:Float=0):Void
  {
    if (asset == null) {
      asset = Mouse.CURSOR_POINTER;
    }

    var cursorData:MouseCursorData = new MouseCursorData();
    cursorData.hotSpot = new Point(hotspotX, hotspotY);
    var bitmaps:Vector<BitmapData> = new Vector();
    bitmaps[0] = Assets.getBitmapData(asset);
    cursorData.data = bitmaps;

    nme.ui.Mouse.registerCursor(asset, cursorData);
    nme.ui.Mouse.cursor = asset;
    // end setCursor
  }

  // end FlashMouseAppearance
}
