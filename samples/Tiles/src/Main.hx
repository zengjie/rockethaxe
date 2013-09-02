package;

import openfl.Assets;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;

import com.rocketshipgames.haxe.world.tilemap.TileCatalog;
import com.rocketshipgames.haxe.world.tilemap.TileChunk;

import com.rocketshipgames.haxe.gfx.sprites.TileMapRenderer;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var graphics:SpritesheetContainer;


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
      (Assets.getBitmapData("assets/test-tiles.png"));
    game.addGraphicsContainer(graphics);

    var catalog = TileCatalog.load(Assets.getText("assets/tile-defs.xml"),
                                   graphics);

    var csv = 
'1, 1, 1, 1, 1
 1, land, 0, 0, 1
 1, 0, 0, land, 1
 water, 0, 0, 0, 1
 1, 1, 1, 1, water';

    var chunk = TileChunk.loadCSV(csv, catalog);

    var tiledraw = new TileMapRenderer();
    tiledraw.map = chunk;
    //    tiledraw.add(chunk);
    graphics.addRenderer(tiledraw);

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // end new
  }

  // end Main
}
