package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.component.Entity;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.Position2D;
import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.Bounds2DComponent;

import com.rocketshipgames.haxe.device.Display;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var bouncerCount:Int;

  public function new():Void
  {
    super();
    trace("Balls Demo");

    game = new ArcadeScreen();
    generateBouncer();

    //-- Start the game
    flash.Lib.current.addChild(game);

    // end new
  }


  private function generateBouncer():Void
  {

    //-- Create a ball!
    var ball = new Entity();

    var kinematics = new Kinematics2DComponent
      ({ xvel: 200, yvel: 200});
    ball.addComponent(kinematics);

    var bounds = new Bounds2DComponent();
    bounds.setBounds(BOUNDS_DETECT,
                     25, 25,
                     Display.width-25, Display.height-25);
    bounds.offBoundsLeft = bounds.bounceLeft;
    bounds.offBoundsRight = bounds.bounceRight;
    bounds.offBoundsTop = bounds.bounceTop;
    bounds.offBoundsBottom = bounds.bounceBottom;
    ball.addComponent(bounds);

    ball.addComponent(new BallShape(game));
    game.world.entities.addComponent(ball);

    bouncerCount++;
    trace(bouncerCount + " bouncers");
    
    game.world.scheduler.schedule(1000, generateBouncer);

    // end generateBouncer
  }


  // end Main
}


//----------------------------------------------------------------------
//----------------------------------------------------------------------
private class BallShape
  extends flash.display.Shape
  implements com.rocketshipgames.haxe.component.Component
{

  private var position:Position2D;

  public function new(parent:flash.display.Sprite):Void
  {
    super();

    graphics.beginFill(0xFF0000);
    graphics.drawCircle(0, 0, 25);
    graphics.endFill();

    parent.addChild(this);
  }

  public function attach(containerHandle:ComponentHandle):Void
  {
    position = cast(containerHandle.findCapability("position-2d"),
                    Position2D);

    update(0);
    // and attach
  }

  public function detach():Void { }

  //------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    x = position.x;
    y = position.y;
  }

  // end BallShape
}
