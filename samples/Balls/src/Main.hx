package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.physics.SweepScanCollisionContainer;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var collisionGroup:SweepScanCollisionContainer;

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
    collisionGroup = new SweepScanCollisionContainer();
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
    var ball = new Bouncer(collisionGroup, graphics);

    //-- Add the new Bouncer to the game and make it live!
    game.world.entities.add(ball);
    
    //-- Schedule another Bouncer to be created in a second
    game.world.scheduler.schedule(1000, generateBouncer);

    bouncerCount++;
    trace(bouncerCount + " bouncers");

    // end generateBouncer
  }

  // end Main
}
