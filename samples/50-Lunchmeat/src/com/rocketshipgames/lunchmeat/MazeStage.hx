/*
 * Copyright (c) 2013 Joe Kopena <tjkopena@gmail.com>
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

package com.rocketshipgames.lunchmeat;

import com.rocketshipgames.haxe.ui.Keyboard;

import com.eclecticdesignstudio.motion.Actuate;

import com.rocketshipgames.haxe.util.TimeUtils;


class MazeStage
  extends com.rocketshipgames.haxe.GameLoop
{

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(?width:Float, ?height:Float):Void
  {
    super(width, height);
    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function fadeout(onComplete:Void->Void = null):Void
  {
    /*
    if (music != null && music.channel != null)
      Actuate.transform(music.channel, 1).sound(0);
    sounds.fadeout();
    */

    Actuate.tween(this, 1, {alpha: 0})
      .onComplete(function() { stop(); if (onComplete != null) onComplete(); });

    // hiding = true;
    // end stop
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function update():Void
  {

    if (Keyboard.isKeyPressed(Keyboard.T)) {
      trace("Time " + TimeUtils.getHumanTime(time) + " (" + time + "); " +
            entityCount + " entities");
    }

    // end update
  }

  // end MazeStage
}
