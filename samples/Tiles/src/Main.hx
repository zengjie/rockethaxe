package;

import openfl.Assets;

import com.rocketshipgames.haxe.device.Mouse;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;

import com.rocketshipgames.haxe.world.tilemap.TileCatalog;
import com.rocketshipgames.haxe.gfx.sprites.TileMapRenderer;
import com.rocketshipgames.haxe.world.tilemap.TileChunk;
import com.rocketshipgames.haxe.physics.impulse.ImpulseTileChunkCollider;

import com.rocketshipgames.haxe.gfx.sprites.GameSpriteCatalog;
import com.rocketshipgames.haxe.gfx.sprites.GameSpriteRenderer;
import com.rocketshipgames.haxe.gfx.sprites.FacingGameSpriteComponent;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;

import com.rocketshipgames.haxe.world.behaviors.KeyboardImpulseComponent;

import com.rocketshipgames.haxe.world.behaviors.ViewportTrackerComponent;

import com.rocketshipgames.haxe.world.ScreenDirection2D;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var spritesheet:SpritesheetContainer;


  //--------------------------------------------------------------------
  public function new():Void
  {

    //------------------------------------------------------------------
    //-- Initialize ----------------------------------------------------

    trace("Tiles Demo");

    // The base Game class sets up the display, mouse, audio, etc
    super();


    // ArcadeScreen is a Screen which drives a game World (entities,
    // mechanics, etc), renders graphics, pauses on unfocus, etc.
    game = new ArcadeScreen();

    // Spritesheets wrap a single bitmap containing multiple frames,
    // which are ultimately used as textures for polygons to draw
    // characters, tiles, etc., with a single memory transfer per
    // frame rather than blitting each one.  This can be just a
    // touch slower on PCs, but is much faster on mobile devices.
    spritesheet = new SpritesheetContainer
      (Assets.getBitmapData("assets/spritesheet.png"));
    game.addGraphicsContainer(spritesheet);


    //------------------------------------------------------------------
    //-- Tilemap -------------------------------------------------------

    // Tile catalogs capture information about map tiles: Size,
    // sprite frame, collision classes, etc.
    var tileCatalog = TileCatalog.load(Assets.getText("assets/tiles.xml"),
                                   spritesheet);

    // A chunk is an array of tiles, here capturing the overhead map.
    var chunk = TileChunk.loadCSV(tileCatalog,
                                  Assets.getText("assets/map.csv"),
                                  TileChunk.autotileRPG);

    // The collider detects and resolves objects colliding with tiles.
    var collider = new ImpulseTileChunkCollider(chunk);
    game.world.mechanics.add(collider);

    // The renderer actually draws the tiles.
    var tiledraw = new TileMapRenderer(chunk);
    spritesheet.addRenderer(tiledraw);

    // Center the viewport over the map to begin with.
    game.viewport.activate({bounds: chunk, drag: true});

    game.viewport.set(((chunk.right()-chunk.left()) - game.viewport.width)/2,
                      ((chunk.bottom()-chunk.top()) - game.viewport.height)/2);


    //------------------------------------------------------------------
    //-- Character -----------------------------------------------------

    // Sprite catalogs collect all of the different sprites on a
    // spritesheet and their information: Size, animations, etc.
    var spriteCatalog =
      GameSpriteCatalog.load(Assets.getText("assets/sprites.xml"), spritesheet);

    // The renderer draws all the sprite instances currently active.
    var sprites = new GameSpriteRenderer();
    spritesheet.addRenderer(sprites);


    // The character is a completely generic RocketHaxe component
    // container to which we'll add functionality.
    var walker = new com.rocketshipgames.haxe.component.ComponentContainer();


    // Get the particular sprite to use in order to pull its dimensions.
    var sprite = spriteCatalog.get("walker");

    // Add a physical body to the walker, a simple box body and basic
    // kinematics properties for walking around at a reasonable pace.
    walker.add(RigidBody2DComponent.newBoxBody
               (0.75*sprite.pixelWidth/game.viewport.pixelsPerMeter,
                0.75*sprite.pixelHeight/game.viewport.pixelsPerMeter,
                {x: (chunk.right()-chunk.left())/2,
                 y: (chunk.bottom()-chunk.top())/2,
                 xvel: 0, yvel: 0,
                 xvelMax: 5, yvelMax: 5,
                 ydrag: 42, xdrag: 42,
                 collidesWith: 1,
                 restitution: 0.5,
                }));

    // Add a generic keyboard controller to the walker.  Custom
    // controls could of course be written.  This component is
    // inserted after the rigid body representation because it's
    // dependent on the body's kinematics, but it's inserted (front of
    // the walker's component list) rather than added (back of the
    // list) because we want it each loop before the kinematics.
    walker.insert(KeyboardImpulseComponent.create({facing: DOWN}));

    // Instantiate a sprite to display the character on screen.  The
    // component used here is a generic default that uses some
    // conventions on the sprite to make it face left/right/up/down
    // and animate when moving.
    walker.add(new FacingGameSpriteComponent(spriteCatalog.get("walker"), true));

    // Have the viewport install a tracking component into the walker.
    game.viewport.track(walker, {margin: Math.max(tileCatalog.width,
                                                  tileCatalog.height) * 4});

    // Finally, make the walker live by adding to the sprite render,
    // tilemap collider, and overall gameworld.
    sprites.add(walker);
    collider.add(walker);
    game.world.entities.add(walker);


    //------------------------------------------------------------------
    //-- Startup -------------------------------------------------------

    // Add the game to the display.  In a real game this would be
    // done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // Display the cursor for dragging the viewport.
    Mouse.enable();

    // end new
  }

  // end Main
}
