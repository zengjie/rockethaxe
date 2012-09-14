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

import com.eclecticdesignstudio.motion.Actuate;

import com.rocketshipgames.haxe.sfx.AudioClip;

class SoundEffectGroup
{

  //------------------------------------------------------------
  public var muted(default,null):Bool = false;
  public var fading(default,null):Bool = false;
  public var volumeControl(default,null):Dynamic;

  //------------------------------------------------------------
  /*
   * Sounds are thrown into a list of SoundEffects and then we loop
   * over that stopping them, rather than keeping a list of playing
   * sounds (SoundChannels), because muting won't happen often so it's
   * not that inefficient and in return we have neither the
   * performance cost nor the complexity of tracking playing sounds,
   * the latter of which gets complex with loops.
   */
  private var effects:List<SoundEffect>;

  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    effects = new List();
    muted = false;
    fading = false;
    // end new
  }

  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public function add(s:SoundEffect):Void
  {
    effects.add(s);
    // end add
  }

  //----------------------------------------------------------------------
  //------------------------------------------------------------
  public function stop():Void
  {
    for (s in effects)
      s.stop();
    // end mute
  }

  public function mute():Void
  {
    muted = true;
    for (s in effects)
      if (s.playing && s.loop)
        s.pause();
      else
        s.stop();
    // end mute
  }

  public function unmute():Void
  {
    muted = false;
    for (s in effects)
      if (s.loop && s.paused)
        s.play();
    // end mute
  }

  public function toggle():Void
  {
    if (muted)
      unmute();
    else
      mute();
    // end toggle
  }

  public function setMute(setMute:Bool):Void
  {
    if (setMute)
      mute();
    else
      unmute();
    // end set
  }

  public function fadeout(duration:Float = 1):Void
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
      // end fadeout
  }

  // end SoundEffectGroup
}
