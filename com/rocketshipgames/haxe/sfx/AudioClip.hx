/*
 * Copyright (c) 2011 Joe Kopena <tjkopena@gmail.com>
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

package com.rocketshipgames.haxe.sfx;

import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import nme.events.Event;

enum ReplayMode {
  RESET;
  CONTINUE;
}

class AudioClip {

  public var playing(default,null):Bool;
  public var paused(default,null):Bool;

  public var loop(default,null):Bool;

  public var channel:SoundChannel;

  //------------------------------------------------------------
  private var sound:Sound;
  private var volume:Float;
  private var replay:ReplayMode;

  private var position:Float;


  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(sound:Sound, opts:Dynamic=null):Void
  {
    this.sound = sound;
    loop = false;
    volume = -1;
    replay = ReplayMode.CONTINUE;

    if (opts != null) {

      var d:Dynamic;
      if ((d = Reflect.field(opts, "loop")) != null) {
        loop = d;
      }

      if ((d = Reflect.field(opts, "volume")) != null) {
        volume = d;
      }

      if ((d = Reflect.field(opts, "replay")) != null) {
        replay = d;
      }

      // end opts
    }

    channel = null;
    playing = false;
    paused = false;

    position = 0.0;

    // end function new
  }

  //--------------------------------------------------------------------
  public function play():Void
  {
    if (channel != null) {
      if (replay == CONTINUE) {
	return;
      } else {
	channel.stop();
      }
    }

    var trans:SoundTransform;
    if (volume != -1) {
      trans = new SoundTransform(volume);
    } else
      trans = new SoundTransform();

    if (loop) {
      /*
       * We want to call play() with a large number of repeats so that
       * there is no gap introduced by delays in the event system
       * calling onComplete() to restart it.  However, this is
       * somewhat tricky and requires special casing, as noted below.
      */

      #if cpp
        /*
         * Passing any value in for the number of repeats on cpp
         * target causes the app to crash on the *second* time you do
         * so.  Not sure if it has to be the same sound or not.  No
         * idea what's going on with that.
         */
        channel = sound.play(position, trans);
      #else
        if (position == 0) {
          /*
           * In this case we can safely give a large number of
           * repeats.
           */
          channel = sound.play(0, 32767, trans);
        } else {
          /*
           * If we're resuming play, we can't give a number of repeats
           * as Flash will then only repeat from that position.
           */
          channel = sound.play(position, trans);
        }
      #end
    } else
      channel = sound.play(position, trans);

    if (channel != null) {
      channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
      playing = true;
      paused = false;
    }
    // end function play
  }

  public function stop():Void
  {
    pause();
    position = 0;
    paused = false;
    // end function stop
  }

  public function pause():Void
  {
    if (!playing)
      return;

    if (channel != null) {
      position = channel.position;
      channel.stop();
    } else {
      position = 0;
    }
    channel = null;
    playing = false;
    paused = true;
    // end pause
  }


  //--------------------------------------------------------------------
  private function onComplete(e:Event):Void
  {
    channel = null;
    playing = false;
    position = 0;
    if (loop)
      play();
    // end function onComplete
  }

  // end class AudioClip
}
