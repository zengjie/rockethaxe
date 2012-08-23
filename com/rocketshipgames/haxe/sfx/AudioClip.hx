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

enum Replay {
  Reset;
  Continue;
}

class AudioClip {

  public var playing:Bool;
  public var channel:SoundChannel;

  //------------------------------------------------------------
  private var sound:Sound;
  private var loop:Bool;
  private var replay:Replay;

  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(sound:Sound, ?replay:Replay):Void
  {

    this.sound = sound;

    if (replay == null)
      this.replay = Continue;
    else
      this.replay = replay;

    loop = false;

    channel = null;
    playing = false;

    // end function new
  }

  //--------------------------------------------------------------------
  public function play(loop:Bool=false, volume:Float=-1):Void
  {
    if (channel != null) {
      if (replay == Continue) {
	return;
      } else {
	channel.stop();
      }
    }

    var trans:SoundTransform;
    if (volume != -1)
      trans = new SoundTransform(volume);
    else
      trans = new SoundTransform();

    this.loop = loop;
    if (loop) {
      #if cpp
        /*
         * Passing any value in for the number of repeats on cpp
         * target causes the app the crash on the *second* time you do
         * so.  Not sure if it has to be the same sound or not.  No
         * idea what's going on with that.
         */
        channel = sound.play(trans);
      #else
        channel = sound.play(0, 32767, trans);
      #end
    } else
      channel = sound.play(trans);

    if (channel != null) {
      channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
      playing = true;
    }
    // end function play
  }

  public function stop():Void
  {
    playing = false;
    loop = false;
    if (channel != null)
      channel.stop();
    channel = null;
    // end function stop
  }


  //--------------------------------------------------------------------
  private function onComplete(e:Event):Void
  {
    channel = null;
    playing = false;
    if (loop)
      play(true);
    // end function onComplete
  }

  // end class AudioClip
}
