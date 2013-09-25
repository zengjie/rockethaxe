package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.physics.impulse.ImpulseColliderAggregator;
import com.rocketshipgames.haxe.physics.impulse.ImpulseObjectCollider;
import com.rocketshipgames.haxe.physics.impulse.ImpulseBoundsCollider;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;

import com.rocketshipgames.haxe.physics.core2d.Bounds2DComponent;
import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;
import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.device.Display;

import Bouncer; // For the enums


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var colliders:ImpulseColliderAggregator;

  private var graphics:DisplayListGraphicsContainer;

  private var count:Int = 0;
  private var color:Int = 0xFFFF00;


  //--------------------------------------------------------------------
  public static function new():Void
  {

    trace("Balls Demo");

    #if !flash
      cpp.vm.Profiler.start("profile.txt");
    #end

    //-- The base Game class sets up the display, mouse, audio, etc
    super();

    //-- ArcadeScreen is a Screen which drives a game World (entities,
    //-- mechanics, etc), renders graphics, pauses on unfocus, etc.
    game = new ArcadeScreen();

    //-- Create the container to collectively collide all the bouncers
    colliders = new ImpulseColliderAggregator();
    colliders.add(new ImpulseObjectCollider());
    colliders.add(new ImpulseBoundsCollider());
    game.world.mechanics.add(colliders);

    //-- Create the container for the bouncers' graphics.  It takes a
    //-- flash.display.Sprite (which an ArcadeScreen ultimately is) as
    //-- the root layer in which to place the graphics.
    graphics = new DisplayListGraphicsContainer(game);
    game.addGraphicsContainer(graphics);

    //-- Add an entity to the world and schedule more
    generateBouncer();

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    #if !flash
    game.world.scheduler.schedule(10000,
                                  function() {
                                    cpp.vm.Profiler.stop();
                                    flash.Lib.exit();
                                  });
    #end

    // end new
  }


  //--------------------------------------------------------------------
  private function generateBouncer():Void
  {

    //-- Bouncer is a simple entity defined in this sample

    var radius:Float = 0.5;
    var mass:Float = 1;
    if (count != 0 && (count % 4 == 2 || count % 4 == 3)) {
      radius = 2;
      mass = 4;
    }

    //-- Every fourth shape we alternate colors
    if (count % 4 == 0) {
      if (color == 0xFF0000)
        color = 0xFFFF00;
      else
        color = 0xFF0000;
    }

    var type = BOX;
    if (count % 3 == 1)
      type = CIRCLE;

    var opts =
      { type: type,
        x: (Display.width/2)/game.viewport.pixelsPerMeter,
        y: -radius*game.viewport.pixelsPerMeter,
        xvel: (Math.random()*16)-8, yvel: 0,
        // xvel: 0, yvel: 0,
        radius: radius,
        width: radius*2, height: radius*2,
        mass: mass,
        gravity: true,
        color: color,
      };


    var ball = Bouncer.create(opts);

    //-- Add new behavior on the basic Bouncer, in this case bounds
    // placeBounds(ball);


    //-- Add the new Bouncer to the game world and display and make it live!
    colliders.addEntity(ball);
    graphics.add(ball);
    game.world.entities.add(ball);


    //-- Schedule another Bouncer to be created in a second
    count++;

    if (count < 18)
      game.world.scheduler.schedule(500, generateBouncer);

    trace(count + " bouncers");

    // end generateBouncer
  }

  // end Main
}
