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

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.World;

import com.rocketshipgames.haxe.game.GameEvent;
import com.rocketshipgames.haxe.game.GameEventsFactory;

import com.rocketshipgames.haxe.game.states.LatchState;
import com.rocketshipgames.haxe.game.states.ConjunctionState;

enum StateEventAction {
  REMOVE;
  LATCH;
  CONJOIN;
}

class StateEvent
  implements GameEvent
{

  //------------------------------------------------------------
  private var world:World;
  private var action:StateEventAction;

  private var ids:Array<String>;
  private var id:String;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(eventsFactory:GameEventsFactory,
                      value:String,
                      params:Hash<String>):Void
  {
    this.world = eventsFactory.demultiplexWorld(params.get("world"));

    var a:String = params.get("action");
    if (a == null) {
      Debug.error("No action in state event.");
      return;
    }

    action = Type.createEnum(StateEventAction, a);

    if (action == REMOVE || action == LATCH || action==CONJOIN) {
      ids = new Array();
      for (s in value.split(",")) {
        ids.push(s);
      }

      id = params.get("id");

      // end REMOVE, LATCH
    } else if (action == CONJOIN) {
    }

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function fire():Void
  {

    switch (action) {
    case REMOVE:
      for (s in ids) {
        world.removeState(s);
      }
      if (id != null) {
        world.removeState(id);
      }

    case LATCH:
      for (s in ids) {
        new LatchState(world, s, s);
      }
      if (id != null) {
        new LatchState(world, id, id);
      }

    case CONJOIN:
      new ConjunctionState(world, id, ids);
      // end switch action
    }

    // end fire
  }

  // end StateEvent
}
