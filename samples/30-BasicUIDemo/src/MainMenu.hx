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

import nme.events.KeyboardEvent;

import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.widgets.MinimalPanel;
import com.rocketshipgames.haxe.ui.PanelManager;

import com.rocketshipgames.haxe.ui.widgets.TextButton;

class MainMenu
  implements Panel
{

  var button:TextButton;
  var button2:TextButton;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    button = new TextButton(nme.Lib.current.stage, gotoGame, "Play Game");
    button.x = nme.Lib.current.stage.stageWidth/2;
    button.y = nme.Lib.current.stage.stageHeight/2;

    button2 = new TextButton(nme.Lib.current.stage, null, "Goto Sub-Menu");
    button2.x = nme.Lib.current.stage.stageWidth/2;
    button2.y = nme.Lib.current.stage.stageHeight/2 + 24;
    // end new
  }

  public function added(manager:PanelManager, id:String):Void {}
  public function removed():Void {}


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    trace("Showing main menu.");

    nme.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

    button.show();
    button2.show();
    // end button
  }

  public function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    trace("Hiding main menu");
    button.hide();
    button2.hide();

    nme.Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN,
                                              onKeyDown);
    onComplete();
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

  // end MainMenu
}
