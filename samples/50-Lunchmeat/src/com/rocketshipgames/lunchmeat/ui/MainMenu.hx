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

package com.rocketshipgames.lunchmeat.ui;

import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

import nme.display.Bitmap;

import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.PanelManager;
import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.widgets.MinimalPanel;

import com.rocketshipgames.haxe.ui.widgets.BitmapButton;
import com.rocketshipgames.haxe.ui.widgets.TextBitmapButton;
import com.rocketshipgames.haxe.ui.widgets.LinearUIWidgetList;

import com.rocketshipgames.haxe.text.TextBitmap;

import com.rocketshipgames.haxe.gfx.Orientation;
import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;
import com.rocketshipgames.haxe.gfx.GrowthDirection;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;

import com.rocketshipgames.haxe.ui.Mouse;


class MainMenu
  extends Sprite,
  implements Panel
{

  private var container:DisplayObjectContainer;
  private var displayWidth:Float;
  private var displayHeight:Float;

  private var panels:PanelManager;

  private var mainMenu:LinearUIWidgetList;


  private var firstTime:Bool;

  private var menuX:Float;
  private var menuY:Float;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObjectContainer,
                      displayWidth:Float, displayHeight:Float):Void
  {
    super();
    this.container = container;
    this.displayWidth = displayWidth;
    this.displayHeight = displayHeight;

    menuX = displayWidth/2;
    menuY = displayHeight/2;

    panels = new PanelManager();
    panels.add("main-menu", new MinimalPanel(showMainPanel, hideMainPanel));
    //    panels.add("controls", new ControlsPanel(this, menuX, menuY));
    //    panels.add("scoreboard", new ScoreboardPanel(this, menuX, menuY));

    //-- Construct the main panel
    mainMenu = new LinearUIWidgetList
      (menuX, menuY,
       this,
       { orientation: VERTICAL,
         horizontalAlignment: HorizontalAlignment.CENTER,
         verticalAlignment: VerticalAlignment.MIDDLE,
       });

    var list:Array<Dynamic> = new Array();

    list.push({action: doGame, text: "Play Game"});

    list.push({
        action: function() { panels.show("controls", { back: "main-menu" }); },
          text: "Customize Controls" });

    list.push
      ({ action: function() { panels.show("scoreboard", {back: "main-menu"}); },
           text: "Scoreboard" });

    list.push({action: null, text: "Lunchmeat VHS!"});

    TextBitmapButton.makeList(mainMenu, list, {color: 0xffffffff}, {}, {}, {});

    // end new
  }

  public function added(manager:PanelManager, id:String):Void {}
  public function removed():Void {}


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {

    firstTime = true;

    container.addChild(this);

    panels.show("main-menu");

    Mouse.goIdle();

    alpha = 1;
    visible = true;

    // end show
  }

  //------------------------------------------------------------
  public function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    Mouse.goIdle();

    Actuate.tween(this, 1, {alpha: 0})
      .onComplete(function() { _hide(onComplete); });
    // end hide
  }

  public function _hide(onComplete:PanelNotifier):Void
  {
    container.removeChild(this);

    onComplete();
    // end _hide
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function showMainPanel(userData:Dynamic, ?opts:Dynamic):Void
  {

    mainMenu.alpha = 1;
    mainMenu.show();

    /*
    if (firstTime && PlayerData.getInstance().newPlayer)
      Actuate.tween(mainMenu, 2, {alpha: 1})
        .delay(3)
        .onComplete(function() { Mouse.show(); } );
    else if (firstTime)
      Actuate.tween(mainMenu, 0.5, {alpha: 1})
        .delay(1)
        .onComplete(function() { Mouse.show(); } );
    else
      Actuate.tween(mainMenu, 0.25, {alpha: 1})
        .onComplete(function() { Mouse.show(); } );
    */

    firstTime = false;

    // end showMainPanel
  }

  private function hideMainPanel(onComplete:PanelNotifier,
                                 userData:Dynamic, ?opts:Dynamic):Void
  {
    mainMenu.hide();
    //mainMenu.visible = false;
    /*
    Actuate.tween(mainMenu, 0.5, {alpha: 0})
      .onComplete(onComplete);
    */
    onComplete();
    // end hideMainPanel
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function doGame():Void
  {
    ScreenManager.show("maze-stage");
    // end doMission
  }

  // end MainMenu
}
