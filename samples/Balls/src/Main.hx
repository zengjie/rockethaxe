package;

import com.rocketshipgames.haxe.component.Entity;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private function new():Void
  {
    super();
    trace("Balls Demo");

    var game = new com.rocketshipgames.haxe.ArcadeScreen();

    var ball = new Entity();

    var opts = { xvel: 200, yvel: 200};
    ball.addComponent(new Kinematics2DComponent(opts));
    ball.addComponent(new BallShape(game));
    game.world.addComponent(ball);

    flash.Lib.current.addChild(game);

    // end new
  }

  // end Main
}


//----------------------------------------------------------------------
//----------------------------------------------------------------------
private class BallShape
  extends flash.display.Shape
  implements com.rocketshipgames.haxe.component.Component
{

  private var physics:Kinematics2DComponent;

  public function new(parent:flash.display.Sprite):Void
  {
    super();

    graphics.beginFill(0xFF0000);
    graphics.drawCircle(0, 0, 100);
    graphics.endFill();

    parent.addChild(this);
  }

  public function attach(containerHandle:ComponentHandle):Void
  {
    physics = cast(containerHandle.findCapability("physics"),
                   Kinematics2DComponent);

    update(0);
    // and attach
  }

  public function detach():Void { }

  //------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    x = physics.x-50;
    y = physics.y-50;
  }

  // end BallShape
}
