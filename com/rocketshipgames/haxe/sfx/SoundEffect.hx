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

import com.eclecticdesignstudio.motion.Actuate;

import com.rocketshipgames.haxe.sfx.AudioClip;

class SoundEffect
  extends AudioClip {

  //------------------------------------------------------------
  private static var mute:Bool = false;
  private static var effects:List<SoundEffect> = new List();
  private static var fading:Bool = false;
  private static var volumeControl:Dynamic;

  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public static function stopAll():Void
  {
    for (s in effects)
      s.stop();
    // end muteAll
  }

  public static function muteAll():Void
  {
    mute = true;
    stopAll();
    // end muteAll
  }

  public static function unmuteAll():Void
  {
    mute = false;
    // end muteAll
  }

  public static function toggleAll():Void
  {
    if (mute)
      unmuteAll();
    else
      muteAll();
    // end toggleAll
  }

  public static function fadeOutAll(duration:Float = 1):Void
  {
    if (fading)
      return;

    fading = true;
    for (s in effects) {
      if (s.channel != null) {
        Actuate.transform(s.channel, duration).sound(0);
      }
    }

    volumeControl = {volume: 1, remainder: duration};
    Actuate.tween(volumeControl, duration, {volume: 0, remainder: 0})
      .onComplete(function() { fading = false; } );
      // end fadeOutAll
  }

  public static function setAll(mute:Bool):Void
  {
    if (mute)
      muteAll();
    else
      unmuteAll();
    // end setAll
  }

  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(sound:Sound, replay:Replay = null):Void
  {
    super(sound, replay);

    /*
     * Every SoundEffect is thrown into this list and then we loop
     * over that stopping them, rather than keeping a list of playing
     * sounds, because muting won't happen often so it's not that
     * inefficient and in return we have neither the performance cost
     * nor the complexity of tracking playing sounds, the latter of
     * which gets complex with loops.
     */

    effects.push(this);
    // end function new
  }

  //--------------------------------------------------------------------
  public override function play(loop:Bool=false, volume:Float = -1):Void
  {
    if (mute)
      return;

    if (fading && volume == -1)
      volume = volumeControl.volume;

    super.play(loop, volume);

    if (fading) {
      Actuate.transform(channel, volumeControl.remainder).sound(0);
    }

    // end function play
  }

  // end class SoundEffect
}
