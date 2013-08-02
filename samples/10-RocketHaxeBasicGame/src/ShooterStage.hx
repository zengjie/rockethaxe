package;

import com.rocketshipgames.haxe.world.World;

class ShooterStage
  extends com.rocketshipgames.haxe.ui.Screen
{

  private var world:World;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    super();
    haxe.Log.trace("New Shooter");

    world = new World();

    // end new
  }

  // end Shooter
}
