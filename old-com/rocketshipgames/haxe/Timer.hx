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

package com.rocketshipgames.haxe;

class Timer
{

  //------------------------------------------------------------
  public var event:Void->Bool;
  public var minInterval:Int;
  public var maxInterval:Int;
  public var loop:Bool;

  //------------------------------------------------------------
  private var container:TimerContainer;

  private var clock:Int;

  private var stopped:Bool;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(event:Void->Bool,
                      minInterval:Int, maxInterval:Int=0,
                      loop:Bool=false):Void
  {
    this.event = event;
    this.minInterval = minInterval;
    if (maxInterval == 0)
      this.maxInterval = minInterval;
    else
      this.maxInterval = minInterval;
    this.loop = loop;

    reset();
    // end new
  }

  public function setContainer(container:TimerContainer):Void
  {
    this.container = container;
    // end setContainer
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function reset():Void
  {
    // maxInterval could be set less than minInterval by client, so
    // the check here prevents anything really weird from happening
    if (maxInterval > minInterval)
    clock = minInterval +
      Std.int(Math.random()*(maxInterval - minInterval));
    else
      clock = minInterval;

    stopped = false;
    // end reset
  }

  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    if (stopped)
      return;

    clock -= elapsed;
    if (clock <= 0) {
      if (event() || !loop) {
        stopped = true;
        if (container != null)
          container.removeTimer(this);
      } else
        reset();
    }
    // end update
  }

  // end Timer
}
