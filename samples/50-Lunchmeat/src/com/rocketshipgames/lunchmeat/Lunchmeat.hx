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

import nme.display.Sprite;

import nme.Assets;

import com.eclecticdesignstudio.motion.Actuate;

// Provides a helper to configure the screen coordinate system, as
// well as the screen dimensions prescribed by the build.
import com.rocketshipgames.haxe.gfx.Screen;

import com.rocketshipgames.haxe.debug.Debug;
import com.rocketshipgames.haxe.debug.DebugConsole;
import com.rocketshipgames.haxe.debug.FPSDisplay;

import com.rocketshipgames.haxe.analytics.Analytics;

import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.widgets.MinimalPanel;

import com.rocketshipgames.haxe.ui.Mouse;


import com.rocketshipgames.lunchmeat.ui.MainMenu;


class Lunchmeat
  extends Sprite
{


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function new():Void
  {
    super();

    // Do this to get the sound system going so there's no delay later
    //new AudioClip(Assets.getSound("assets/sfx/upgrade.wav"), {volume: 0}).play();

    Mouse.enable();

    //-- Set up the screens
    ScreenManager.add("main-menu", new MainMenu
                      (this, Screen.width, Screen.height));

    ScreenManager.add("maze-stage", new MinimalPanel(showMaze, hideMaze));

    ScreenManager.show("main-menu");

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function showMaze(userData:Dynamic, ?opts:Dynamic):Void
  {
    var mazeStage:MazeStage;

    mazeStage = new MazeStage();

    mazeStage.alpha = 0;
    addChild(mazeStage);
    Actuate.tween(mazeStage, 1, {alpha: 1});

    userData.mazeStage = mazeStage;

    // end showmission
  }

  private function hideMaze(onComplete:PanelNotifier,
                            userData:Dynamic, ?opts:Dynamic):Void
  {
    var mazeStage:MazeStage = userData.mazeStage;
    mazeStage.fadeout(function() { removeChild(mazeStage); onComplete(); });
    // end hideMission
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  static public function main()
  {
    com.rocketshipgames.haxe.gfx.Screen.configureStandard();

    var game:Lunchmeat = new Lunchmeat();
    nme.Lib.current.stage.addChild(game);

    #if flash
      new DebugConsole();
    #end

    // Instate analytics and Mochi here

    #if debug
      nme.Lib.current.stage.addChild
        (new com.rocketshipgames.haxe.debug.FPSDisplay
         (0xffffff,
          com.rocketshipgames.haxe.gfx.Screen.width-18,
          com.rocketshipgames.haxe.gfx.HorizontalAlignment.RIGHT));
    #end

    // end main
  }

  // end Sprite
}
