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

import nme.events.KeyboardEvent;

import nme.text.TextFormatAlign;

import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

import com.eclecticdesignstudio.motion.Actuate;

import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.widgets.MinimalPanel;
import com.rocketshipgames.haxe.ui.PanelManager;

import com.rocketshipgames.haxe.ui.widgets.TextBitmapButton;
import com.rocketshipgames.haxe.ui.widgets.LinearUIWidgetList;

import com.rocketshipgames.haxe.gfx.Orientation;
import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;
import com.rocketshipgames.haxe.gfx.GrowthDirection;

import com.rocketshipgames.haxe.ui.Mouse;


class MainMenu
  extends Sprite,
  implements Panel
{

  //------------------------------------------------------------
  private var container:DisplayObjectContainer;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObjectContainer):Void
  {
    super();
    this.container = container;

    var uiList:LinearUIWidgetList;

    var style:Dynamic =
      { borderWidth: 2, padding: 2,
        justification:TextFormatAlign.LEFT,
      };
    var upColors:Dynamic = { bgcolor: 0xffffffff, color: 0xff000000 };
    var overColors:Dynamic = { bgcolor: 0xff000000, color: 0xffffffff };
    var downColors:Dynamic = { bgcolor: 0xff000000, color: 0xff333333 };

    uiList = new LinearUIWidgetList
      (320, 240, this,
       { orientation: VERTICAL,
         horizontalAlignment: HorizontalAlignment.CENTER,
         verticalAlignment: VerticalAlignment.MIDDLE,
         horizontalJustification: HorizontalAlignment.CENTER,
       });

    //-- Place a bunch of buttons into the list
    TextBitmapButton.makeList
      (uiList,
       [ {action: gotoGame, text: "Play Game"},
         {action: doSettings, text: "Settings"},
         {action: doAbout, text: "About"},
         {action: doHelp, text: "Help!"} ],
       style, upColors, overColors, downColors);


    //-- Manually construct another list and place at bottom of list
    var uiList2:LinearUIWidgetList;
    uiList2 = new LinearUIWidgetList
      (0, 0,
       { orientation: HORIZONTAL,
         horizontalAlignment: HorizontalAlignment.LEFT,
         verticalAlignment: VerticalAlignment.TOP});

    Reflect.deleteField(style, "borderBottomWidth");
    uiList2.add(new TextBitmapButton
               (null, "Sponsor",
                style, upColors, overColors, downColors));
    uiList2.add(new TextBitmapButton
               (function() {
                 nme.Lib.getURL
                   (new nme.net.URLRequest("http://rocketshipgames.com"));
                },
                "rocketshipgames.com",
                style, upColors, overColors, downColors));
    uiList2.add(new TextBitmapButton
               (null, "Sponsor",
                style, upColors, overColors, downColors));
    uiList.add(uiList2);

    uiList.show();

    // end new
  }

  public function added(manager:PanelManager, id:String):Void {}
  public function removed():Void {}


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    trace("Showing main menu.");

    container.addChild(this);

    nme.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

    Mouse.enable();

    // end button
  }

  public function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    trace("Hiding main menu");

    Mouse.disable();

    nme.Lib.current.stage.removeEventListener
      (KeyboardEvent.KEY_DOWN, onKeyDown);

    Actuate.tween(this, 1, {alpha: 0})
      .onComplete(function() {
          parent.removeChild(this);
          onComplete();
        });

    // end hide
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function onKeyDown(e:KeyboardEvent):Void
  {
    gotoGame();
  }

  private function gotoGame():Void
  {
    ScreenManager.show("shooter");
    // end gotoGame
  }

  private function doSettings():Void
  {
    trace("SETTINGS!");
    Mouse.setCursorHand();
    // end doSettings
  }

  private function doAbout():Void
  {
    trace("ABOUT!");
    Mouse.setCursorMiniPointer();
    // end doAbout
  }

  private function doHelp():Void
  {
    trace("HELP!");
    Mouse.setCursor();
    // end doAbout
  }

  // end MainMenu
}
