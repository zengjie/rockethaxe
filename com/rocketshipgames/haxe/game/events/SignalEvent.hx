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

import com.rocketshipgames.haxe.game.GameEvent;
import com.rocketshipgames.haxe.game.GameEventsFactory;

class SignalEvent
  implements GameEvent
{

  public var world:World;

  private var id:String;
  private var signal:Dynamic;

  public function new(eventsFactory:GameEventsFactory,
                      value:String,
                      params:Hash<String>):Void
  {
    this.world = eventsFactory.demultiplexWorld(params.get("world"));

    id = params.get("id");
    params.remove("id");

    if (value != null && value != "") {
      signal = value;
    } else if (params.iterator().hasNext()) {
        signal = {};
        for (k in params.keys()) {
          Reflect.setField(signal, k, params.get(k));
        }

        GameEventUtils.getX(world, params, signal);
        GameEventUtils.getScreenX(world, params, signal);
        GameEventUtils.getX(world, params, signal, "targetX");

        GameEventUtils.getY(world, params, signal);
        GameEventUtils.getScreenY(world, params, signal);
        GameEventUtils.getY(world, params, signal, "targetY");
    } else
      signal = null;

    // end new
  }

  public function fire():Void
  {
    world.signal(id, signal);
    // end fire
  }

  // end SignalEvent
}
