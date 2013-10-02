package;

import openfl.Assets;

import flash.events.MouseEvent;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.device.Mouse;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;

import com.rocketshipgames.haxe.world.tilemap.TileCatalog;
import com.rocketshipgames.haxe.gfx.sprites.TileMapRenderer;
import com.rocketshipgames.haxe.world.tilemap.TileChunk;
import com.rocketshipgames.haxe.physics.impulse.ImpulseTileChunkCollider;

import com.rocketshipgames.haxe.gfx.sprites.GameSpriteCatalog;
import com.rocketshipgames.haxe.gfx.sprites.GameSpriteRenderer;
import com.rocketshipgames.haxe.gfx.sprites.FacingGameSpriteComponent;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;

import com.rocketshipgames.haxe.world.behaviors.ViewportTrackerComponent;
import com.rocketshipgames.haxe.world.behaviors.KeyboardImpulseComponent;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var spritesheet:SpritesheetContainer;

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

    spritesheet = new SpritesheetContainer
      (Assets.getBitmapData("assets/spritesheet.png"));
    game.addGraphicsContainer(spritesheet);


    var tileCatalog = TileCatalog.load(Assets.getText("assets/tiles.xml"),
                                   spritesheet);

    var chunk = TileChunk.loadCSV(tileCatalog,
                                  Assets.getText("assets/map.csv"),
                                  TileChunk.autotileRPG);

    var tiledraw = new TileMapRenderer(chunk);
    spritesheet.addRenderer(tiledraw);

    //-- Create the container to collectively collide all the bouncers
    var collider = new ImpulseTileChunkCollider(chunk);
    game.world.mechanics.add(collider);



    var spriteCatalog =
      GameSpriteCatalog.load(Assets.getText("assets/sprites.xml"),
                             spritesheet);
    var sprites = new GameSpriteRenderer();
    spritesheet.addRenderer(sprites);



    //-- Center the viewport over the map
    game.viewport.x = ((chunk.right()-chunk.left()) - game.viewport.width)/2;
    game.viewport.y = ((chunk.bottom()-chunk.top()) - game.viewport.height)/2;


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

    /*
    var sprites = new com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer(game);
    game.addGraphicsContainer(sprites);
    */

    var walker = new com.rocketshipgames.haxe.component.ComponentContainer();

    var sprite = spriteCatalog.get("walker");

    walker.add(RigidBody2DComponent.newBoxBody
               (0.75*sprite.pixelWidth/game.viewport.pixelsPerMeter,
                0.75*sprite.pixelHeight/game.viewport.pixelsPerMeter,
                {x: (chunk.right()-chunk.left())/2,
                    y: (chunk.bottom()-chunk.top())/2,
                   // x: 0, y: 0,
                    xvel: 0, yvel: 0,
                    xvelMax: 5, yvelMax: 5,
                    ydrag: 42, xdrag: 42,
                    collidesWith: 1,
                    restitution: 0.5,
                    }));

    //-- The keyboard controls are inserted after the rigid body
    //-- because they're dependent on the body's kinematics, but
    //-- they're inserted rather than added because we want them
    //-- processed each loop before the kinematics.
    walker.insert(KeyboardImpulseComponent.create());

    var x = new FacingGameSpriteComponent(spriteCatalog.get("walker"));
    trace("Original " + Type.getClassName(Type.getClass(x)));

    walker.add(x);

    /*
    var shape = new flash.display.Shape();
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawRect(-size*game.viewport.pixelsPerMeter/2,
                            -size*game.viewport.pixelsPerMeter/2,
                            size*game.viewport.pixelsPerMeter,
                            size*game.viewport.pixelsPerMeter);
    shape.graphics.endFill();
    walker.add(new com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent(shape));
    // walker.add(ViewportTrackerComponent.create(game.viewport));

    */

    sprites.add(walker);

    collider.add(walker);


    game.world.entities.add(walker);

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // end new
  }

  // end Main
}


