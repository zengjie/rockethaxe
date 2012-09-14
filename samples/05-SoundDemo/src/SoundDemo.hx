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

import nme.Assets;

import com.rocketshipgames.haxe.sfx.AudioClip;
import com.rocketshipgames.haxe.sfx.SoundEffect;
import com.rocketshipgames.haxe.sfx.SoundEffectGroup;

import nme.events.KeyboardEvent;
import com.rocketshipgames.haxe.ui.Keyboard;

class SoundDemo
{

  public static var applause:SoundEffect;
  public static var elephant:SoundEffect;
  public static var machinegun:SoundEffect;
  public static var pauseElephant:SoundEffect;

  public static var group:SoundEffectGroup;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private static function onKeyDown(event:KeyboardEvent):Void
  {

    if (event.keyCode == Keyboard.A) {
      applause.play();

    } else if (event.keyCode == Keyboard.E) {
      elephant.play();

    } else if (event.keyCode == Keyboard.M) {
      if (machinegun.playing)
        machinegun.stop();
      else
        machinegun.play();

    } else if (event.keyCode == Keyboard.I) {
      if (pauseElephant.playing)
        pauseElephant.pause();
      else
        pauseElephant.play();

    } else if (event.keyCode == Keyboard.QUOTE) {
      var e:SoundEffect = new SoundEffect
        (Assets.getSound("assets/elephant.mp3"), {loop: true});
      group.add(e);
      e.play();
    } else if (event.keyCode == Keyboard.COMMA) {
      group.toggle();
    }

    // end onKeyDown
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  static public function main()
  {

    group = new SoundEffectGroup();

    applause = new SoundEffect(Assets.getSound("assets/applause.mp3"));
    elephant = new SoundEffect(Assets.getSound("assets/elephant.mp3"),
                               {replay: ReplayMode.RESET});
    machinegun = new SoundEffect(Assets.getSound("assets/machinegun.mp3"),
                                 {loop: true});
    pauseElephant = new SoundEffect(Assets.getSound("assets/elephant.mp3"));

    nme.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

    trace("A for applause (continues)");
    trace("E for elephant (resets)");
    trace("M for machine gun loop (start/stop)");
    trace("I for elephant (pause/resume)");
    trace("' to add to looping elephant chorus");
    trace(", to toggle elephant chorus (mute/unmute)");

    // end main
  }


  // end SoundDemo
}
