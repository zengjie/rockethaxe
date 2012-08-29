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

import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.widgets.MinimalPanel;
import com.rocketshipgames.haxe.ui.PanelManager;

class BasicUIDemo
{

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  static public function main():Void
  {
    trace("Basic UI Demo");

    com.rocketshipgames.haxe.ui.StageUtils.setStandardConfiguration();

    //-- Set up the screens
    ScreenManager.add("main-menu", new MainMenu());

    ScreenManager.add
      ("shooter",
       new MinimalPanel
       (function(userData:Dynamic, ?opts:Dynamic):Void {
         trace("Showing shooter.");
         userData.game = new RocketHaxeBasicGame(640, 480);
         nme.Lib.current.stage.addChild(userData.game);
       },

         function (onComplete:PanelNotifier,
                   userData:Dynamic, ?opts:Dynamic):Void {
         trace("Hiding shooter.");
         userData.game.stop();
         nme.Lib.current.stage.removeChild(userData.game);
         onComplete();
       }));


    //-- Show the main menu
    ScreenManager.show("main-menu");

    // end main
  }

  // end BasicUIDemo
}
