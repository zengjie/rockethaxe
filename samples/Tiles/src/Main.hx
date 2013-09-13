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

import com.rocketshipgames.haxe.physics.core2d.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.world.behaviors.ViewportTrackerComponent;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;


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
                              game.viewport.x -= e.localX-mx;

                              if (game.viewport.x < chunk.left())
                                game.viewport.x = chunk.left();

                              if (game.viewport.x > chunk.right()-game.viewport.width)
                                game.viewport.x = chunk.right() - game.viewport.width;

                              game.viewport.y -= e.localY-my;

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

    walker.add(Kinematics2DComponent.create
               ({  x: (chunk.right()-chunk.left())/2,
                   y: (chunk.bottom()-chunk.top())/2,
                   xvel: 0, yvel: 0,
                   xvelMin: 2, yvelMin: 2,
                   xvelMax: 250, yvelMax: 250,
                   ydrag: 5000, xdrag: 5000}));

    walker.insert(new WalkerKeyboard());

    var shape = new flash.display.Shape();
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawRect(-12.5, -12.5, 25, 25);
    shape.graphics.endFill();
    walker.add(new com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent(shape));
    walker.add(ViewportTrackerComponent.create(game.viewport));

    sprites.add(walker);
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
      kinematics.xacc = 1000;
    else if (Keyboard.isKeyDown(Keyboard.LEFT))
      kinematics.xacc = -1000;

    if (Keyboard.isKeyDown(Keyboard.UP))
      kinematics.yacc = -1000;
    else if (Keyboard.isKeyDown(Keyboard.DOWN))
      kinematics.yacc = 1000;

    // end update
  }

  // end WalkerKeyboard
}
