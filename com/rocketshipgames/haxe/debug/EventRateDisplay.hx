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

/*
 * Derived from FPS display in NME-RunnerMark by Philippe Elsass.
 */

package com.rocketshipgames.haxe.debug;

import nme.Assets;

import nme.events.Event;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;

class EventRateDisplay extends TextField {

  private var events:Int;
  private var prevEvents:Int;

  private var eventTimes:Array<Float>;

  private var label:String;

  private static var stack:Float = 0.0;

  private var fontName:String = null;

  public function new(labelText:String,
                      color:Int=0xffffff,
                      posx:Float=0, posy:Float=-1):Void
  {
    super();

    if (fontName == null) {
      var font = Assets.getFont("assets/fonts/nokiafc22.ttf");
      if (font != null)
        fontName = font.fontName;
      else
        fontName = "sans";
    }

    label = labelText;

    x = posx;

    if (posy < 0) {
      y = stack;
    } else {
      y = posy;
    }

    autoSize = LEFT;
    defaultTextFormat = new TextFormat(fontName, 8, color, true);
    htmlText = label + ": 0";
    multiline = false;
    selectable = false;
    stack += textHeight;

    eventTimes = [];
    events = prevEvents = 0;
    // end new
  }

  public function event():Void
  {
    var t = nme.Lib.getTimer() / 1000.0;
    eventTimes.push(t);
    while (eventTimes[0] < t-1) {
      eventTimes.shift();
    }
    events = eventTimes.length;

    if (visible && (prevEvents != events)) {
      prevEvents = events;
      htmlText = label + ": " + events;
    }
    // end onEnterFrame
  }

  // end EventRateDisplay
}
