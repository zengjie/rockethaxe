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
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;

import com.rocketshipgames.haxe.gfx.HorizontalAlignment;


class EventRateDisplay
  extends TextField
{

  //------------------------------------------------------------
  private var events:Int;
  private var prevEvents:Int;

  private var eventTimes:Array<Float>;

  private var label:String;

  private static var stack:Float = 0;

  private var align:HorizontalAlignment;

  private var baseX:Float;
  private var baseY:Float;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(label:String,
                      color:Int=0xffffff,
                      x:Float=0, y:Float=-1,
                      align:HorizontalAlignment=null):Void
  {
    super();
    this.label = label;

    if (x < 0)
      x += com.rocketshipgames.haxe.gfx.Screen.width;
    baseX = x;

    if (y < 0)
      y = stack;
    baseY = y;

    if (align == null)
      align = LEFT;
    this.align = align;


    /*
    private var fontName:String = "sans";
    var font = Assets.getFont("assets/fonts/nokiafc22.ttf");
    if (font != null)
      fontName = font.fontName;
    else
      fontName = "sans";
    */

    //-- Create the actual textfield and put into display
    autoSize = LEFT;
    defaultTextFormat = new TextFormat("sans", 8, color, true);
    text = label + ": 0";
    multiline = false;
    selectable = false;

    adjustPosition();

    nme.Lib.current.stage.addChild(this);


    //-- Prepared to track events
    eventTimes = [];
    events = prevEvents = 0;


    //-- Setup for the next display
    stack += textHeight;

    // end new
  }

  //------------------------------------------------------------
  private function adjustPosition():Void
  {
    switch (align) {
    case LEFT:
      x = baseX;

    case CENTER:
      x = baseX - textWidth/2;

    case RIGHT:
      x = baseX - (textWidth+4);
    }
    // end adjustPosition
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
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
      text = label + ": " + events;
      adjustPosition();
    }
    // end onEnterFrame
  }

  // end EventRateDisplay
}
