package;

import openfl.Assets;

import flash.events.MouseEvent;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.device.Mouse;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;

import com.rocketshipgames.haxe.world.tilemap.TileCatalog;
import com.rocketshipgames.haxe.world.tilemap.TileChunk;

import com.rocketshipgames.haxe.gfx.sprites.TileMapRenderer;


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
                              game.viewport.x -= e.localX-mx;
                              game.viewport.y -= e.localY-my;
                              mx = e.localX;
                              my = e.localY;
                            }
                          });

    var codes = [
                 { code: 16, label: "surrounded" },
                 { code: 1, label: "top" },
                 { code: 2, label: "left" },
                 { code: 4, label: "right" },
                 { code: 8, label: "bottom" }
                 ];

    var TOP:Int = 1;
    var LEFT:Int = 8;
    var RIGHT:Int = 2;
    var BOTTOM:Int = 4;
    var MIDDLE:Int = 16;

    for (i in 0...32) {
      var s = "<tile label=\"";
      var prev = false;
      for (c in codes) {
        if ((i & c.code) != 0) {
          s += ((prev)?"-":"") + c.label;
          prev = true;
        }
      }

      s += "\" frame=\"\" />";
      trace(s);
    }


    graphics = new SpritesheetContainer
      (Assets.getBitmapData("assets/RPGTiles.png"));
    game.addGraphicsContainer(graphics);

    graphics.addFrame(0, 0, 64, 32, 0, 0);
    graphics.addFrame(0, 0, 64, 32, 0, 0);

    var catalog = TileCatalog.load(Assets.getText("assets/tile-defs.xml"),
                                   graphics);


var csv =
'0, 0, 0, 0, 0, 0
 0, 2, 2, 2, 2, 0
 0, 2, 0, 0, 2, 0
 0, 0, 0, 0, 0, 0
 0, 0, 0, 0, 0, 0
 0, 2, 2, 2, 2, 0
 0, 0, 0, 0, 0, 0
 0, 0, 0, 0, 0, 0
 1, 1, 1, 1, 1, 1
';

    /*
    var csv = 
'0, 0, 0, 0, 0, 0
 0, 2, 0, 0, 1, 0
 0, 0, 0, 0, 0, 0';
    */

    /*
    var csv = 
'0, 0, 0, 0, 0, 0
 0, 2, 2, 2, 2, 0
 0, 2, 2, 2, 2, 0
 0, 2, 2, 2, 2, 0
 0, 0, 0, 0, 0, 0';
    */

    /*
    var csv = 
'0, 0, 0, 0, 0, 0
 0, 1, 1, 1, 1, 0
 0, 1, 1, 1, 1, 0
 0, 1, 1, 1, 1, 0
 0, 0, 0, 0, 0, 0';
   */

    /*
    var csv = 
'1, 1, 1, 1, 1, 1
 1, 0, 0, 0, 0, 1
 1, 0, 0, 0, 0, 1
 1, 0, 0, 0, 0, 1
 1, 1, 1, 1, 1, 1';
    */

    /*
    var csv = 
'15, 15, 15, 15, 15, 15, 15
 15, 7, 3, 3, 3, 11, 15
 15, 5, 0, 0, 0, 10, 15
 15, 5, 0, 0, 0, 10, 15
 15, 5, 0, 0, 0, 10, 15
 15, 13, 12, 12, 12, 14, 15
 15, 15, 15, 15, 15, 15, 15';
    */

    var chunk = TileChunk.loadCSV(catalog, csv);

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
