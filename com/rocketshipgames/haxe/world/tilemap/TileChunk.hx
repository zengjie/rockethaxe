package com.rocketshipgames.haxe.world.tilemap;


class TileChunk {

  public var catalog(default,null):TileCatalog;

  public var tiles(default,null):Array<Tile>;
  public var width(default,null):Int;
  public var height(default,null):Int;


  //----------------------------------------------------


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(catalog:TileCatalog):Void
  {
    this.catalog = catalog;
    tiles = new Array();

    //-- HACK
    width = 5;
    height = 5;

    var map = [
             [1, 1, 1, 1, 1],
             [1, 0, 0, 0, 1],
             [1, 0, 0, 0, 1],
             [1, 0, 0, 0, 1],
             [1, 1, 1, 1, 1]
             ];


    var x:Int, y:Int;

    y = 0;
    while (y < height) {
      var row = map[y];

      x = 0;
      while (x < width) {
        var tile = catalog.get(row[x]);
        trace(tile.label + " at " + x + "," + y);

        tiles[(y*width)+x] = tile;

        x++;
      }

      y++;
    }

    // end new
  }

  // end TileChunk
}
