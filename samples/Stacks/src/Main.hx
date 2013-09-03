package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.physics.RigidBodyImpulseCollisionContainer;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.RigidBody2DComponent;
import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.device.Display;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var collisionGroup:RigidBodyImpulseCollisionContainer;

  private var graphics:DisplayListGraphicsContainer;


  //--------------------------------------------------------------------
  public function new():Void
  {
    trace("Stacks Demo");

    //-- The base Game class sets up the display, mouse, audio, etc
    super();

    //-- ArcadeScreen is a Screen which drives a game World (entities,
    //-- mechanics, etc), renders graphics, pauses on unfocus, etc.
    game = new ArcadeScreen();

    //-- Create the container to collectively collide all the bouncers
    collisionGroup = new RigidBodyImpulseCollisionContainer();
    game.world.mechanics.add(collisionGroup);

    //-- Create the container for the bouncers' graphics.  It takes a
    //-- flash.display.Sprite (which an ArcadeScreen ultimately is) as
    //-- the root layer in which to place the graphics.
    graphics = new DisplayListGraphicsContainer(game);
    game.addGraphicsContainer(graphics);

    //-- Setup the initial configuration
    generateStacks();

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);
    game.setPaused(true, true);

    com.rocketshipgames.haxe.device.Mouse.enable();
    flash.Lib.current.stage.addEventListener
      (flash.events.MouseEvent.CLICK,
       function(e:flash.events.MouseEvent):Void {
        game.setPaused(false);
      });

    // end new
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  private function generateStacks():Void
  {

    var rows = 4;
    var columns = 4;

    for (r in 0...rows) {
      for (c in 0...columns) {
        generateBouncer(Bouncer.BOX, 25, 5,
                        (c+1)*(Display.width/(columns+1)),
                        (r+1)*(Display.height/(rows+1)));
      }
    }

    game.world.scheduler.schedule(1000,
                        function() {
                          generateBouncer(Bouncer.CIRCLE, 50, 10,
                                          Display.width/2, -50);
                        });
    game.world.scheduler.schedule(2000,
                        function() {
                          generateBouncer(Bouncer.CIRCLE, 50, 10,
                                          Display.width/2, -50);
                        });

  /*
    generateBouncer(Bouncer.CIRCLE, 50, 10, 
    generateBouncer(Bouncer.CIRCLE, 50, 10, Display.width/4, 75);
    generateBouncer(Bouncer.CIRCLE, 50, 10, 3*Display.width/4, 75);
  */

    generateBar();

    // end GenerateStacks
  }

  //----------------------------------------------------
  private function generateBouncer(type:Int, radius:Float, mass:Float,
                                   x:Float, y:Float):Void
  {
    var ball = new Bouncer(type, radius, mass, x, y);
    collisionGroup.add(ball);
    graphics.add(ball);
    game.world.entities.add(ball);
    // end generateBouncer
  }

  //----------------------------------------------------
  private function generateBar():Void
  {

    var bar = new com.rocketshipgames.haxe.component.ComponentContainer();

    //-- Add basic position and movement
    bar.add(Kinematics2DComponent.create
        ({ x: Display.width/2, y: 552,
            xvel: 0, yvel: 0,
            xvelMin: 2, yvelMin: 2}));


    bar.add(RigidBody2DComponent.newBoxBody(320, 24, 1, 1,
                                            { mass: 1000,
                                             fixed: true}));

    var shape = new flash.display.Shape();
    shape.graphics.lineStyle(1);
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawRect(-160, -12, 320, 24);
    shape.graphics.endFill();
    bar.add(new DisplayListGraphicComponent(shape));

    collisionGroup.add(bar);
    graphics.add(bar);
    game.world.entities.add(bar);

    // end generateBar
  }

  // end Main
}
