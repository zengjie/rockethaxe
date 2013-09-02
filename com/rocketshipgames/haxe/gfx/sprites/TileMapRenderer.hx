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

    y = 0;
    while (y < map.rows) {

      x = 0;
      while (x < map.columns) {
        container.drawFrame(x*map.catalog.width, y*map.catalog.height,
                            map.tiles[(y*map.columns)+x].frame);
        x++;
      }

      y++;
    }

    // end render
  }

  // end SpritesheetRenderer
}
