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

import nme.Assets;

import com.rocketshipgames.haxe.sfx.SoundEffect;

import com.rocketshipgames.haxe.game.GameEvent;

class SoundEvent
  implements GameEvent
{

  public var sound:SoundEffect;
  public var loop:Bool;
  public var world:World;
  public var signal:String;

  public function new(eventsFactory:GameEventsFactory,
                      path:String, params:Hash<String>):Void
  {
    if ((sound = new SoundEffect(Assets.getSound(path))) == null)
      trace("Could not load sound " + path);

    var d:String;
    if ((d = params.get("loop")) != null && d == "true")
      loop = true;
    else
      loop = false;

    if ((d = params.get("signal")) != null) {
      signal = d;
      world = eventsFactory.demultiplexWorld(params.get("world"));
      world.addSignal(signal, stop);
    }

    // end new
  }

  public function stop(id:String, message:Dynamic):Bool
  {
    sound.stop();
    return true;
    // end stop
  }

  public function fire():Void
  {
    if (sound != null)
      sound.play(loop);
    // end fire
  }

  // end TextEvent
}
