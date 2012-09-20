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

import com.rocketshipgames.haxe.World;
import com.rocketshipgames.haxe.game.GameEventWrapper;

class BlockingGameEventWrapper
  implements GameEventWrapper
{

  //------------------------------------------------------------
  private var world:World;
  private var signals:List<String>;
  private var states:List<StateReference>;

  private var registered:Bool;

  private var triggeredSignals:Int;

  private var event:GameEvent;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(eventsFactory:GameEventsFactory,
                      params:Hash<String>):Void
  {
    world = eventsFactory.demultiplexWorld(params.get("world"));
    signals = new List();
    states = new List();
    registered = false;
    triggeredSignals = 0;

    var str = params.get("when");
    params.remove("when");

    var i:Int = -1;
    var s:Int = 0;

    while (s < str.length) {
      if ((i = str.indexOf(",", s)) == -1)
        i = str.length;

      var id:String = str.substr(s, i-s);
      if (id.charAt(0) == "@") {
        var negate:Bool = false;

        if (id.charAt(1) == "!") {
          negate = true;
          id = id.substr(2);
        } else
          id = id.substr(1);

        states.push(new StateReference(id, negate));
      } else {
        signals.push(id);
      }

      s = i+1;
    }

    // end new
  }

  public function setEvent(event:GameEvent):Void
  {
    this.event = event;
    // end setEvent
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function activate(id:String, message:Dynamic):Bool
  {
    triggeredSignals++;
    return true;
    // end activate
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function process(elapsed:Int):Bool
  {
    if (!registered) {
      registered = true;
      for (i in signals)
        world.addSignal(i, activate);
    }

    var statesReady:Bool = true;
    var d:Dynamic;
    for (i in states) {
      d = world.getStateValue(i.state);
      if (i.negate && (d != null && d != false)) {
        statesReady = false;
        break;
      } else if (!i.negate && (d == null || d == false)) {
        statesReady = false;
        break;
      }
    }

    if (triggeredSignals >= signals.length && statesReady) {
      event.fire();
      return true;
    }

    return false;
    // end process
  }

  // end BlockingGameEventWrapper
}


private class StateReference
{
  public var state:String;
  public var negate:Bool;

  public function new(state:String, negate:Bool):Void
  {
    this.state = state;
    this.negate = negate;
    // end new
  }

  // end StateReference
}
