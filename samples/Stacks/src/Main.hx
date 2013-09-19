package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.physics.impulse.ImpulseObjectCollider;
import com.rocketshipgames.haxe.physics.impulse.ImpulseColliderAggregator;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;

import com.rocketshipgames.haxe.physics.core2d.Bounds2DComponent;
import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;
import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.device.Display;

import Bouncer;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var colliders:ImpulseColliderAggregator;

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
    colliders = new ImpulseColliderAggregator();
    colliders.add(new ImpulseObjectCollider());
    game.world.mechanics.add(colliders);

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
        addBouncer(Bouncer.createBox(50, 50,
                                     { x: (c+1)*(Display.width/(columns+1))+r*2,
                                       y: (r+1)*(Display.height/(rows+1)),
                                         mass: 5, gravity: true }));
      }
    }

    game.world.scheduler.schedule(1000,
                        function() {
                                    addBouncer(Bouncer.createCircle(50,
                                                                    {x: Display.width/2, y: -50, mass: 50, gravity: true})); });

    game.world.scheduler.schedule(2000,
                        function() {
                                    addBouncer(Bouncer.createCircle(50,
                                                                    {x: Display.width/2, y: -50, mass: 50, gravity: true})); });

    generateBar();

    // end GenerateStacks
  }


  //----------------------------------------------------
  private function addBouncer(bouncer:Bouncer):Void
  {
    bouncer.placeBounds(REMOVE);

    colliders.addEntity(bouncer);
    graphics.add(bouncer);
    game.world.entities.add(bouncer);
    // end addBouncer
  }


  //----------------------------------------------------
  private function generateBar():Void
  {

    var bar = new com.rocketshipgames.haxe.component.ComponentContainer();

    //-- Add basic position and movement
    bar.add(RigidBody2DComponent.newBoxBody(320, 24,
                                            {
                                              x: Display.width/2, y: 552,
                                                xvel: 0, yvel: 0,
                                                xvelMin: 2, yvelMin: 2,
                                                mass: 1000,
                                                fixed: true,
                                                collidesAs: 1, collidesWith: 1,
                                                }));

    var shape = new flash.display.Shape();
    shape.graphics.lineStyle(1);
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawRect(-160, -12, 320, 24);
    shape.graphics.endFill();
    bar.add(new DisplayListGraphicComponent(shape));

    colliders.addEntity(bar);
    graphics.add(bar);
    game.world.entities.add(bar);

    // end generateBar
  }

  // end Main
}
