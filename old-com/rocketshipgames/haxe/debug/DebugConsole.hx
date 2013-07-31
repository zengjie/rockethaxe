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

package com.rocketshipgames.haxe.debug;

import nme.events.Event;

import com.rocketshipgames.haxe.text.widgets.LogGameTextList;

class DebugConsole
{

  private var log:LogGameTextList;
  private var prevFrameTimestamp:Int;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    log = new LogGameTextList(nme.Lib.current.stage);
    log.defaultOpts = {size: 8, alpha:0.5};
    // log.defaultDuration = 1000;

    haxe.Log.trace = function(v,?pos) {
      log.receiveText(pos.className.substr(pos.className.lastIndexOf(".")+1) +
                      "#" + pos.methodName + "(" + pos.lineNumber + "): "+ v);
    }

    nme.Lib.current.stage.addEventListener(Event.ADDED, onAdded);
    nme.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function onAdded(e:Event=null):Void
  {
    prevFrameTimestamp = nme.Lib.getTimer();
    // end function onStage
  }

  private function onEnterFrame(e:Event=null):Void
  {
    var currTime:Int = nme.Lib.getTimer();
    log.render(null, currTime - prevFrameTimestamp);
    prevFrameTimestamp = currTime;
    // end onEnterFrame
  }

  // end DebugConsole
}
