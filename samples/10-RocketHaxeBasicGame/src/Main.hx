package;

import com.rocketshipgames.haxe.ui.ScreenManager;

class Main
  extends com.rocketshipgames.haxe.Game
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    super();
    haxe.Log.trace("Basic Game");

    ScreenManager.add("menu", new Menu());
    ScreenManager.add("game", new ShooterStage());
    ScreenManager.show("menu");

    // end new
  }

  // end main
}
