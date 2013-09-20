package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.world.tilemap.TileChunk;


class TileMapRenderer
  implements SpritesheetRenderer
{

  private var container:SpritesheetContainer;

  public var map:TileChunk;

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    // end new
  }

  //----------------------------------------------------
  public function attach(container:SpritesheetContainer):Void
  {
    this.container = container;
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(viewport:com.rocketshipgames.haxe.gfx.Viewport):Void
  {
    //    trace("Render tilemap");

    var x:Int, y:Int;
    var frame:Int;

    y = 0;
    while (y < map.rows) {

      x = 0;
      while (x < map.columns) {
        frame = map.tile(x, y).frame;

        if (frame >= 0) {
          container.drawFrame(Math.floor((x*map.catalog.width)-viewport.x),
                              Math.floor((y*map.catalog.height)-viewport.y),
                              frame);
        }

        x++;
      }

      y++;
    }

    // end render
  }

  // end SpritesheetRenderer
}
