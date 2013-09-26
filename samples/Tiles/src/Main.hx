package;

import openfl.Assets;

import flash.events.MouseEvent;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.device.Mouse;
import com.rocketshipgames.haxe.device.Keyboard;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;

import com.rocketshipgames.haxe.world.tilemap.TileCatalog;
import com.rocketshipgames.haxe.world.tilemap.TileChunk;

import com.rocketshipgames.haxe.gfx.sprites.TileMapRenderer;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;
import com.rocketshipgames.haxe.physics.core2d.Kinematics2DComponent;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.world.behaviors.ViewportTrackerComponent;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.impulse.ImpulseTileChunkCollider;



class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var graphics:SpritesheetContainer;

  private var dragging:Bool;
  private var mx:Float;
  private var my:Float;


  //--------------------------------------------------------------------
  public function new():Void
  {
    trace("Tiles Demo");

    //-- The base Game class sets up the display, mouse, audio, etc
    super();

    //-- ArcadeScreen is a Screen which drives a game World (entities,
    //-- mechanics, etc), renders graphics, pauses on unfocus, etc.
    game = new ArcadeScreen();

    graphics = new SpritesheetContainer
      (Assets.getBitmapData("assets/RPGTiles.png"));
    game.addGraphicsContainer(graphics);


    /**
     * These are here just to show/test that other graphics can be
     * extracted from the spritesheet before the TileCatalog.
     */
    graphics.addFrame(0, 0, 64, 32, 0, 0);
    graphics.addFrame(0, 0, 64, 32, 0, 0);

    var catalog = TileCatalog.load(Assets.getText("assets/tile-defs.xml"),
                                   graphics);


var csv =
'1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1
 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1
 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1
 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1
 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1
 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1
 1, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 1, 1
 1, 1, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1
 1, 1, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1
 1, 1, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 1, 1
 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1
 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1, 1
 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 2, 2, 0, 0, 0, 0, 1, 1
 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 2, 2, 0, 0, 0, 1, 1
 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 1, 1, 1
 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1
 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
';

    var chunk = TileChunk.loadCSV(catalog, csv, TileChunk.autotileRPG);

    trace("Chunk " + chunk.left() + "," + chunk.top() + " -- " +
          chunk.right() + "," + chunk.bottom());

    var tiledraw = new TileMapRenderer();
    tiledraw.map = chunk;
    graphics.addRenderer(tiledraw);

    //    game.viewport.x = ((chunk.right()-chunk.left()) - game.viewport.width)/2;
    //   game.viewport.y = ((chunk.bottom()-chunk.top()) - game.viewport.height)/2;

    Mouse.enable();
    flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN,
                          function(e:MouseEvent):Void { dragging = true;
                            mx = e.localX; my = e.localY; });
    flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP,
                          function(e:MouseEvent):Void { dragging = false; });
    flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE,
                          function(e:MouseEvent):Void {
                            if (dragging) {
                              // These are substractions because we
                              // move the viewport in the opposite
                              // direction, as if dragging the map as
                              // opposed to moving the view.
                              game.viewport.x -= (e.localX-mx)/
                                game.viewport.pixelsPerMeter;

                              if (game.viewport.x < chunk.left())
                                game.viewport.x = chunk.left();

                              if (game.viewport.x > chunk.right()-game.viewport.width)
                                game.viewport.x = chunk.right() - game.viewport.width;

                              game.viewport.y -= (e.localY-my)/
                                game.viewport.pixelsPerMeter;

                              if (game.viewport.y < chunk.top())
                                game.viewport.y = chunk.top();

                              if (game.viewport.y > chunk.bottom()-game.viewport.height)
                                game.viewport.y = chunk.bottom() - game.viewport.height;


                              mx = e.localX;
                              my = e.localY;
                            }
                          });

    var sprites = new com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer(game);
    game.addGraphicsContainer(sprites);

    var walker = new com.rocketshipgames.haxe.component.ComponentContainer();

    var size = 1;
    walker.add(RigidBody2DComponent.newBoxBody
               (size, size,
                {x: (chunk.right()-chunk.left())/2,
                    y: (chunk.bottom()-chunk.top())/2,
                   // x: 0, y: 0,
                    xvel: 0, yvel: 0,
                    xvelMax: 5, yvelMax: 5,
                    ydrag: 42, xdrag: 42,
                    collidesWith: 1,
                    restitution: 0.5,
                    }));

    walker.insert(new WalkerKeyboard());

    var shape = new flash.display.Shape();
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawRect(-size*game.viewport.pixelsPerMeter/2,
                            -size*game.viewport.pixelsPerMeter/2,
                            size*game.viewport.pixelsPerMeter,
                            size*game.viewport.pixelsPerMeter);
    shape.graphics.endFill();
    walker.add(new com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent(shape));
    // walker.add(ViewportTrackerComponent.create(game.viewport));

    sprites.add(walker);

    //-- Create the container to collectively collide all the bouncers
    var collider = new ImpulseTileChunkCollider(chunk);
    collider.add(walker);
    game.world.mechanics.add(collider);

    game.world.entities.add(walker);

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // end new
  }

  // end Main
}


private class WalkerKeyboard
  implements com.rocketshipgames.haxe.component.Component
{

  private var kinematics:Kinematics2DComponent;


  public function new():Void
  {
  }

  public function attach(container:ComponentHandle):Void
  {
    kinematics = cast(container.find(PhysicsCapabilities.CID_KINEMATICS2D),
                      Kinematics2DComponent);
  }

  public function detach():Void
  {
  }

  public function activate(?opts:Dynamic):Void
  {
  }
  public function deactivate():Void
  {
  }

  public function update(elapsed:Int):Void
  {
    kinematics.xacc = kinematics.yacc = 0.0;

    if (Keyboard.isKeyDown(Keyboard.RIGHT))
      kinematics.xacc = 84;
    else if (Keyboard.isKeyDown(Keyboard.LEFT))
      kinematics.xacc = -84;

    if (Keyboard.isKeyDown(Keyboard.UP))
      kinematics.yacc = -84;
    else if (Keyboard.isKeyDown(Keyboard.DOWN))
      kinematics.yacc = 84;

    // end update
  }

  // end WalkerKeyboard
}
