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

package com.rocketshipgames.haxe.game.events;

import com.rocketshipgames.haxe.game.GameEventWrapper;

class TimeoutGameEventWrapper
  implements GameEventWrapper
{

  private var event:GameEvent;
  private var timeout:Int = 0;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(params:Hash<String>):Void
  {
    var str:String = params.get("in");
    if (str != null) {
      timeout = Std.parseInt(str);
      params.remove("in");
    } else
      timeout = 0;
    // end new
  }

  public function setEvent(event:GameEvent):Void
  {
    this.event = event;
    // end setEvent
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function process(elapsed:Int):Bool
  {
    timeout -= elapsed;

    if (timeout <= 0) {
      event.fire();
      return true;
    }

    return false;
    // end process
  }

  // end TimeoutGameEvent
}
