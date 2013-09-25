package;

import openfl.Assets;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;

import com.rocketshipgames.haxe.physics.impulse.ImpulseColliderAggregator;
import com.rocketshipgames.haxe.physics.impulse.ImpulseObjectCollider;
import com.rocketshipgames.haxe.physics.impulse.ImpulseTileChunkCollider;
import com.rocketshipgames.haxe.physics.impulse.ImpulseBoundsCollider;

import com.rocketshipgames.haxe.world.tilemap.TileCatalog;
import com.rocketshipgames.haxe.world.tilemap.TileChunk;
import com.rocketshipgames.haxe.gfx.sprites.TileMapRenderer;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;

import Bouncer; // Imported for the BouncerBoundsAction enum


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var sprites:DisplayListGraphicsContainer;

  private var colliders:ImpulseColliderAggregator;


  //--------------------------------------------------------------------
  public function new():Void
  {
    trace("Waterfall Demo");

    //-- The base Game class sets up the display, mouse, audio, etc
    super();

    //-- ArcadeScreen is a Screen which drives a game World (entities,
    //-- mechanics, etc), renders graphics, pauses on unfocus, etc.
    game = new ArcadeScreen();


    var graphics = new SpritesheetContainer
      (Assets.getBitmapData("assets/tiles.png"));
    game.addGraphicsContainer(graphics);

    var catalog = TileCatalog.load(Assets.getText("assets/tiles.xml"),
                                   graphics,
                                   game.viewport.pixelsPerMeter);

    var csv =
'0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
 0, 0, 0, 1, 1, 0, 1, 0, 0, 0
 1, 0, 0, 1, 1, 1, 1, 1, 0, 0
 1, 1, 0, 1, 1, 0, 1, 0, 0, 0
 1, 0, 0, 0, 1, 0, 0, 0, 0, 1
 1, 0, 0, 0, 0, 0, 0, 0, 1, 1';
 

    var chunk = TileChunk.loadCSV(catalog, csv);

    var tiledraw = new TileMapRenderer();
    tiledraw.map = chunk;
    graphics.addRenderer(tiledraw);

    //game.viewport.x = ((chunk.right()-chunk.left()) - game.viewport.width)/2;
    //game.viewport.y = ((chunk.bottom()-chunk.top()) - game.viewport.height)/2;

    sprites = new DisplayListGraphicsContainer(game);
    game.addGraphicsContainer(sprites);

    //-- Create the container to collectively collide all the bouncers
    colliders = new ImpulseColliderAggregator();
    colliders.add(new ImpulseObjectCollider());
    colliders.add(new ImpulseTileChunkCollider(chunk));
    colliders.add(new ImpulseBoundsCollider());
    game.world.mechanics.add(colliders);
    colliders.iterations = 8;

    game.world.scheduler.schedule(1000, generateBouncer);

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // end new
  }

  //----------------------------------------------------
  private function generateBouncer():Void
  {

    var bouncer = Bouncer.create({type: BOX,
                                  xvel: 2*Math.random()*20,
                                  gravity: true});

    bouncer.placeBounds(REMOVE);

    colliders.addEntity(bouncer);
    sprites.add(bouncer);
    game.world.entities.add(bouncer);

    game.world.scheduler.schedule(1000, generateBouncer);

    // end generateBouncer
  }

  // end Main
}
