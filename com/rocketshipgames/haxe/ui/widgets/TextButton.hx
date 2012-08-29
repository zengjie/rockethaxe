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

import nme.events.Event;
import nme.events.MouseEvent;

import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.BitmapData;

import com.rocketshipgames.haxe.text.TextBitmap;

class TextButton
  extends Sprite
{
  private var container:DisplayObjectContainer;
  private var action:Void->Void;

  private var bitmap:Bitmap;

  private var onGraphic:BitmapData;
  private var overGraphic:BitmapData;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObjectContainer,
                      action:Void->Void,
                      text:String):Void
  {
    super();
    this.container = container;
    this.action = action;

    bitmap = new Bitmap();
    addChild(bitmap);

    onGraphic = TextBitmap.makeBitmapData(text);
    overGraphic = TextBitmap.makeBitmapData(text, { bgcolor: 0xffffffff,
                                                    color: 0x000000 });

    addEventListener(MouseEvent.CLICK, click);
    addEventListener(MouseEvent.ROLL_OVER, rollOver);
    addEventListener(MouseEvent.ROLL_OUT, rollOut);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show():Void
  {
    trace("Showing button");
    bitmap.bitmapData = onGraphic;
    visible = true;
    container.addChild(this);
    // end show
  }

  public function hide():Void
  {
    trace("Hiding button");
    visible = false;
    container.removeChild(this);
    // end hide
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function click(e:Event):Void
  {
    trace("Click");
    if (action != null)
      action();
    // end click
  }

  private function rollOver(e:Event):Void
  {
    trace("Roll over");
    bitmap.bitmapData = overGraphic;
    // end rollOver
  }

  private function rollOut(e:Event):Void
  {
    trace("Roll out");
    bitmap.bitmapData = onGraphic;
    // end rollOut
  }

  // end TextButton
}
