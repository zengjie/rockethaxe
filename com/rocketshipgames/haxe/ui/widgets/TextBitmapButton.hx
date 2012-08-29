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

import com.rocketshipgames.haxe.text.TextBitmap;

class TextBitmapButton
  extends Button
{

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

    super(container, action,
          TextBitmap.makeBitmap(text, _up),
          TextBitmap.makeBitmap(text, _over),
          TextBitmap.makeBitmap(text, _down));
    // end new
  }

  // end TextButton
}
