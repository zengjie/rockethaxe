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

    var r:Int, c:Int;
    var frame:Int;

    r = 0;
    while (r < map.rows) {

      c = 0;
      while (c < map.columns) {
        frame = map.tile(c, r).frame;

        if (frame >= 0) {

          container.drawFrame
            (Math.floor(((map.x-viewport.x) + (c*map.catalog.width)) * viewport.pixelsPerMeter),
             Math.floor(((map.y-viewport.y) + (r*map.catalog.height)) * viewport.pixelsPerMeter),
             frame);
        }

        c++;
      }

      r++;
    }

    // end render
  }

  // end SpritesheetRenderer
}
