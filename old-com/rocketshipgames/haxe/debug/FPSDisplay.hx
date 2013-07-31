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
 * Originally derived from utility in NME-RunnerMark by Philippe Elsass.
 */

package com.rocketshipgames.haxe.debug;

import nme.Lib;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.Event;

import com.rocketshipgames.haxe.gfx.HorizontalAlignment;


class FPSDisplay extends EventRateDisplay {

  public function new(?color:Int,
                      ?x:Float, ?y:Float,
                      ?align:HorizontalAlignment):Void
  {
    super("FPS", color, x, y, align);
    addEventListener(Event.ENTER_FRAME, onEnterFrame);
    // end new
  }

  private function onEnterFrame(_):Void {
    event();
  }

  // end FPSDisplay
}
