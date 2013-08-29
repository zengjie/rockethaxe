package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.physics.RigidBodyImpulseCollisionContainer;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;

import com.rocketshipgames.haxe.physics.Bounds2DComponent;
import com.rocketshipgames.haxe.device.Display;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var collisionGroup:RigidBodyImpulseCollisionContainer;

  private var graphics:DisplayListGraphicsContainer;


  private var bouncerCount:Int;


  //--------------------------------------------------------------------
  public function new():Void
  {
    trace("Balls Demo");

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

    //-- Add an entity to the world and schedule more
    generateBouncer();

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // end new
  }


  //--------------------------------------------------------------------
  private function generateBouncer():Void
  {

    //-- Bouncer is a simple entity defined in this sample
    var ball = new Bouncer();

    //-- Add new behavior on the basic Bouncer, in this case bounds
    placeBounds(ball);


    //-- Add the new Bouncer to the game world and display and make it live!
    collisionGroup.add(ball);
    graphics.add(ball);
    game.world.entities.add(ball);


    //-- Schedule another Bouncer to be created in a second
    if (bouncerCount < 9)
      game.world.scheduler.schedule(500, generateBouncer);

    bouncerCount++;
    trace(bouncerCount + " bouncers");

    // end generateBouncer
  }


  private function placeBounds(ball:Bouncer):Void
  {

    /*
     * The Bouncer could impose bounds on itself, but in this sample
     * it's just a basic object that flies around.  The outer game
     * imposes bounds on that movement by adding a new component.
     */

    var bounds = new Bounds2DComponent();
    bounds.setBounds(0, 0, Display.width, Display.height);

    //-- Bounds2DComponent contains a number of common bounds
    //-- reactions, such as stopX, bounceX, cannotLeaveX, cycleX, and
    //-- doNothing, where X is Left, Right, Top, Bottom.
    bounds.offBoundsLeft = bounds.bounceLeft;
    bounds.offBoundsRight = bounds.bounceRight;
    bounds.offBoundsTop = bounds.bounceTop;

    //-- But a user defined function can also be specified.
    bounds.offBoundsBottom = function() { trace("BOTTOM");
                                          bounds.bounceBottom(); }

    //-- By default Bounds2DComponent doesn't issue a signal, but we
    //-- can turn it on so other components are notified.
    bounds.enableSignal();

    ball.add(bounds);

    // end placeBounds
  }

  // end Main
}
