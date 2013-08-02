package;

import openfl.Assets;

import com.rocketshipgames.haxe.ui.ScreenManager;

/*
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.widgets.MinimalPanel;
import com.rocketshipgames.haxe.ui.PanelManager;
*/

import com.rocketshipgames.haxe.device.Mouse;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private function new():Void
  {
    super();
    trace("Basic UI Demo");

    //-- Set up the screens
    ScreenManager.add("main-menu", new MainMenu());
    ScreenManager.show("main-menu");

    /*
    ScreenManager.add
      ("shooter",
       new MinimalPanel
       (function(userData:Dynamic, ?opts:Dynamic):Void {
         trace("Showing shooter.");
         userData.game = new RocketHaxeBasicGame(640, 480);
         userData.game.alpha = 0;
         addChild(userData.game);
         Actuate.tween(userData.game, 1, {alpha: 1});
       },

         function (onComplete:PanelNotifier,
                   userData:Dynamic, ?opts:Dynamic):Void {
         trace("Hiding shooter.");
         userData.game.stop();
         removeChild(userData.game);
         onComplete();
       }));
    */

    // end new
  }

  // end Main
}
