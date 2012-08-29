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

package com.rocketshipgames.haxe.game.scenarios;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.text.TextReceiver;

import com.rocketshipgames.haxe.game.GameEvent;
import com.rocketshipgames.haxe.game.GameEventWrapper;
import com.rocketshipgames.haxe.game.GameEventsFactory;

import com.rocketshipgames.haxe.game.events.BlockingGameEventWrapper;
import com.rocketshipgames.haxe.game.events.TimeoutGameEventWrapper;

import com.rocketshipgames.haxe.game.events.TextEvent;
import com.rocketshipgames.haxe.game.events.SoundEvent;
import com.rocketshipgames.haxe.game.events.SpawnAreaTriggerEvent;
import com.rocketshipgames.haxe.game.events.SignalEvent;
import com.rocketshipgames.haxe.game.events.StateEvent;

class TimeOrderedEventScript
{

  //------------------------------------------------------------
  private var eventsFactory:GameEventsFactory;

  private var eventQueue:List<GameEventWrapper>;

  private var paused:Bool;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(eventsFactory:GameEventsFactory):Void
  {
    this.eventsFactory = eventsFactory;
    eventQueue = new List();
    paused = false;
    // end new
  }

  //------------------------------------------------------------
  public function pause():Void
  {
    paused = true;
    // end pause
  }

  public function resume():Void
  {
    paused = false;
    // end resume
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function loadScript(xml:String):Void
  {
    var root = Xml.parse(xml).firstElement();

    for (cmdNode in root.elements()) {
      var cmd:String = cmdNode.nodeName;

      var value:String =
        (cmdNode.firstChild() != null) ? cmdNode.firstChild().nodeValue : null;

      var params:Hash<String> = new Hash();
      for (att in cmdNode.attributes())
        params.set(att, cmdNode.get(att));

      var wrapper:GameEventWrapper;
      if (params.exists("when"))
        wrapper = new BlockingGameEventWrapper(eventsFactory, params);
      else
        wrapper = new TimeoutGameEventWrapper(params);

      var event:GameEvent = null;

      //------------------------------------------------
      //-- Parse specific events

      if (cmd == "text") {
        event = new TextEvent(eventsFactory, value, params);

      } else if (cmd == "sound") {
        event = new SoundEvent(eventsFactory, value, params);

      } else if (cmd == "area-trigger") {
        event = new SpawnAreaTriggerEvent(eventsFactory, params);

      } else if (cmd == "signal") {
        event = new SignalEvent(eventsFactory, value, params);

      } else if (cmd == "state") {
        event = new StateEvent(eventsFactory, value, params);

      } else {
        event = eventsFactory.generateEvent(cmd, params, value);

        // end custom event
      }

      //-- End parsing specific events
      //------------------------------------------------

      if (event == null) {
        Debug.error("Unknown event " + cmd + " or other error parsing.");
        continue;
      }

      wrapper.setEvent(event);
      eventQueue.add(wrapper);

      // end parse command
    }
    // end loadScript
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function update(elapsed:Int)
  {
    if (paused)
      return;

    var current:GameEventWrapper;
    while ((current = eventQueue.first()) != null && current.process(elapsed))
      eventQueue.pop();

    // end updateToNow
  }

  // end TimeOrderedEventScript
}
