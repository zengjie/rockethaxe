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

import com.rocketshipgames.haxe.game.GameEvent;
import com.rocketshipgames.haxe.game.GameEventsFactory;
import com.rocketshipgames.haxe.game.GameEventUtils;

import com.rocketshipgames.haxe.text.TextReceiver;

import com.rocketshipgames.haxe.World;

class TextEvent
  implements GameEvent
{

  public var world:World;
  public var receiver:TextReceiver;

  public var text:String;
  public var opts:Dynamic;

  public var onSignal:String = null;
  public var removeSignal:String = null;

  public function new(eventsFactory:GameEventsFactory,
                      text:String, params:Hash<String>):Void
  {
    world = eventsFactory.demultiplexWorld(params.get("world"));
    receiver = eventsFactory.demultiplexText(params.get("channel"));

    if (!params.exists("notrim")) {
      var i:Int = 0;
      var k:Int = text.length-1;
      while (i < text.length &&
             (text.charAt(i) == ' ' ||
              text.charAt(i) == "\t" ||
              text.charAt(i) == "\n"))
        i++;
      while (k >= 0 &&
             (text.charAt(k) == ' ' ||
              text.charAt(k) == "\t" ||
              text.charAt(k) == "\n"))
        k--;
      k++;
      this.text = text.substr(i, k-i); // substring() throws warning on cpp?
    } else {
      this.text = text;
      params.remove("notrim");
    }

    if (params.exists("onSignal")) {
      onSignal = params.get("onSignal");
      params.remove("onSignal");
    }
    if (params.exists("removeSignal")) {
      removeSignal = params.get("removeSignal");
      params.remove("removeSignal");
    }

    opts = {};
    for (k in params.keys()) {
      Reflect.setField(opts, k, params.get(k));
    }

    // Overwrite specials with calculated positions if exist

    GameEventUtils.getX(world, params, opts);
    GameEventUtils.getY(world, params, opts);
    GameEventUtils.getScreenX(world, params, opts);
    GameEventUtils.getScreenY(world, params, opts);

    // end new
  }

  public function remove(id:String, message:Dynamic = null):Bool
  {
    //trace("Removing TextEvent signals " + onSignal + " " + removeSignal);
    world.removeSignal(onSignal, trigger);
    world.removeSignal(removeSignal, remove);
    return false;
    // end remove
  }

  public function trigger(id:String, message:Dynamic = null):Bool
  {
    //trace("Trigger " + onSignal);
    receiver.receiveText(text, opts);
    remove(id, message);
    return false;
    // end trigger
  }

  public function fire():Void
  {
    if (onSignal != null) {
      world.addSignal(onSignal, trigger);
      if (removeSignal != null)
        world.addSignal(removeSignal, remove);
    } else {
      receiver.receiveText(text, opts);
    }
    // end fire
  }

  // end TextEvent
}
