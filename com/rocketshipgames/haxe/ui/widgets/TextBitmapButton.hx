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
import nme.display.SimpleButton;
import nme.display.Bitmap;
import nme.display.BitmapData;

import com.rocketshipgames.haxe.text.TextBitmap;

import com.rocketshipgames.haxe.ui.UIWidget;

class TextBitmapButton
  extends SimpleButton,
  implements UIWidget
{
  private var container:DisplayObjectContainer;
  private var action:Void->Void;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObjectContainer,
                      action:Void->Void,
                      text:String,
                      ?defaultStyle:Dynamic,
                      ?upStyle:Dynamic,
                      ?overStyle:Dynamic,
                      ?downStyle:Dynamic):Void
  {

    var _up = Reflect.copy(defaultStyle);
    for (f in Reflect.fields(upStyle))
      Reflect.setField(_up, f, Reflect.field(upStyle, f));

    var _over = Reflect.copy(defaultStyle);
    for (f in Reflect.fields(overStyle))
      Reflect.setField(_over, f, Reflect.field(overStyle, f));

    var _down = Reflect.copy(defaultStyle);
    for (f in Reflect.fields(downStyle))
      Reflect.setField(_down, f, Reflect.field(downStyle, f));

    var over:Bitmap;
    super(TextBitmap.makeBitmap(text, _up),
          (over = TextBitmap.makeBitmap(text, _over)),
          TextBitmap.makeBitmap(text, _down),
          over);

    this.container = container;
    this.action = action;

    addEventListener(MouseEvent.CLICK, click);

    trace("Width is " + width);

    /*
    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
    addEventListener(MouseEvent.MOUSE_UP, mouseUp);
    addEventListener(MouseEvent.ROLL_OVER, rollOver);
    addEventListener(MouseEvent.ROLL_OUT, rollOut);
    */

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show():Void
  {
    trace("Showing button");
    container.addChild(this);
    // end show
  }

  public function hide():Void
  {
    trace("Hiding button");
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

  /*
  private function mouseDown(e:Event):Void
  {
    trace("Mouse down");
    // end mouseUp
  }

  private function mouseUp(e:Event):Void
  {
    trace("Mouse up");
    // end mouseUp
  }

  private function rollOver(e:Event):Void
  {
    trace("Roll over");
    // end rollOver
  }

  private function rollOut(e:Event):Void
  {
    trace("Roll out");
    // end rollOut
  }
  */

  // end TextButton
}
