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
  extends BitmapButton
{

  var upText:TextBitmap;
  var overText:TextBitmap;
  var downText:TextBitmap;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(action:Void->Void,
                      text:String,
                      ?defaultStyle:Dynamic,
                      ?upStyle:Dynamic,
                      ?overStyle:Dynamic,
                      ?downStyle:Dynamic,
                      ?container:DisplayObjectContainer):Void
  {
    var _up = Reflect.copy(defaultStyle);
    if (upStyle != null) {
      for (f in Reflect.fields(upStyle))
        Reflect.setField(_up, f, Reflect.field(upStyle, f));
    }

    var _over = Reflect.copy(defaultStyle);
    if (overStyle != null) {
      for (f in Reflect.fields(overStyle))
        Reflect.setField(_over, f, Reflect.field(overStyle, f));
    }

    var _down = Reflect.copy(defaultStyle);
    if (downStyle != null) {
      for (f in Reflect.fields(downStyle))
        Reflect.setField(_down, f, Reflect.field(downStyle, f));
    }

    upText = new TextBitmap(text, _up);
    overText = new TextBitmap(text, _over);
    downText = new TextBitmap(text, _down);

    super(action, upText.bitmap, overText.bitmap, downText.bitmap, container);

    // end new
  }

  //--------------------------------------------------------------------
  public function setText(string:String):Void
  {
    upText.draw(string);
    overText.draw(string);
    downText.draw(string);

    upBitmap = upText.bitmap;
    overBitmap = overText.bitmap;
    downBitmap = downText.bitmap;
    updateGraphicState();
    // end setText
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function makeList(widgetList:UIWidgetList,
                                  buttons:Array<Dynamic>,
                                  ?defaultStyle:Dynamic,
                                  ?upStyle:Dynamic,
                                  ?overStyle:Dynamic,
                                  ?downStyle:Dynamic,
                                  ?opts:Dynamic):Void
  {
    var dropTopBorder:Bool = true;

    if (opts != null) {
      var d:Dynamic;
      if ((d = Reflect.field(opts, "dropTopBorder")) != null)
        dropTopBorder = d;
    }

    var entry:Dynamic;
    entry = buttons.shift();
    if (entry != null) {
      widgetList.add(new TextBitmapButton
                     (entry.action, entry.text,
                      defaultStyle, upStyle, overStyle, downStyle));
    }

    if (dropTopBorder) {
      Reflect.setField(defaultStyle, "borderTopWidth", 0);
    }

    for (entry in buttons) {
      widgetList.add(new TextBitmapButton
                     (entry.action, entry.text,
                      defaultStyle, upStyle, overStyle, downStyle));
    }

    // end makeList
  }

  // end TextButton
}
