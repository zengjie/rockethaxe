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

    var row:Int, col:Int, minRow:Int, maxRow:Int, minCol:Int, maxCol:Int;
    var frame:Int;

    minCol = Math.floor((viewport.x-map.left())/map.catalog.width);
    if (minCol < 0)
      minCol = 0;

    minRow = Math.floor((viewport.y-map.top())/map.catalog.height);
    if (minRow < 0)
      minRow = 0;

    maxCol = minCol + Math.floor(viewport.width/map.catalog.width) + 1;
    if (maxCol > map.columns)
      maxCol = map.columns;

    maxRow = minRow + Math.floor(viewport.height/map.catalog.height) + 1;
    if (maxRow > map.rows)
      maxRow = map.rows;

    var dx:Int,
      basedx:Int = Math.floor(((map.left()-viewport.x) +
                               (minCol*map.catalog.width)) *
                              viewport.pixelsPerMeter);
    var dy:Int = Math.floor(((map.top()-viewport.y) +
                             (minRow*map.catalog.height)) *
                            viewport.pixelsPerMeter);

    row = minRow;
    while (row < maxRow) {

      dx = basedx;
      col = minCol;
      while (col < maxCol) {
        frame = map.tile(col, row).frame;

        if (frame >= 0)
          container.drawFrame(dx, dy, frame);

        dx += map.catalog.pixelWidth;
        col++;
      }

      dy += map.catalog.pixelHeight;
      row++;
    }

    // end render
  }

  // end SpritesheetRenderer
}
