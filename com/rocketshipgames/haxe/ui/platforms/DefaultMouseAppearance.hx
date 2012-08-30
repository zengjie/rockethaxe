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

import nme.display.Bitmap;
import nme.display.BitmapData;

import com.eclecticdesignstudio.motion.Actuate;

import com.rocketshipgames.haxe.ui.Mouse;

class DefaultMouseAppearance
  implements MouseAppearanceWrapper
{

  private var cursor:Bitmap;
  private var hotspotX:Float;
  private var hotspotY:Float;

  private var fading:Bool;

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
    this.cursor = new Bitmap();
    this.cursor.visible = false;
    this.hotspotX = 0;
    this.hotspotY = 0;

    fading = false;

    setCursor(cursor, hotspotX, hotspotY);

    nme.Lib.current.stage.addChild(this.cursor);
    // end enable
  }

  public function disable():Void
  {
    nme.Lib.current.stage.removeChild(cursor);
    // end disable
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function updateVisibility(visibility:Bool):Void
  {
    cursor.visible = visibility;
    if (visibility) {
      if (fading) {
        Actuate.stop(cursor, {alpha: null}, false, false);
        fading = false;
      }
      cursor.alpha = 1;
    }
    // end updateVisibility
  }

  //------------------------------------------------------------
  public function updatePosition(x:Float, y:Float):Void
  {
    cursor.x = x - hotspotX;
    cursor.y = y - hotspotY;
    // end updatePosition
  }

  //------------------------------------------------------------
  public function idleOut():Void
  {
    fading = true;
    Actuate.tween(cursor, 1, {alpha: 0});
    // end idleOut
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function setCursor(?asset:String=null,
                            ?hotspotX:Float=0, ?hotspotY:Float=0):Void
  {
    if (asset == null)
      cursor.bitmapData = Assets.getBitmapData(Mouse.CURSOR_POINTER);
    else
      cursor.bitmapData = Assets.getBitmapData(asset);

    cursor.x += this.hotspotX;
    cursor.y += this.hotspotY;

    this.hotspotX = hotspotX;
    this.hotspotY = hotspotY;

    cursor.x -= this.hotspotX;
    cursor.y -= this.hotspotY;
    // end setCursor
  }

  // end DefaultMouseAppearance
}
