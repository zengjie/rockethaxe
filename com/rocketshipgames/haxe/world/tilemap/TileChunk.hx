package com.rocketshipgames.haxe.world.tilemap;

import com.rocketshipgames.haxe.debug.Debug;


class TileChunk {

  public var catalog(default,null):TileCatalog;

  public var tiles(default,null):Array<Tile>;
  public var columns(default,null):Int;
  public var rows(default,null):Int;

  public var x:Float;
  public var y:Float;

  //----------------------------------------------------

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(catalog:TileCatalog):Void
  {
    this.catalog = catalog;
    tiles = new Array();

    this.x = this.y = 0.0;
    this.columns = this.rows = -1;

    // end new
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function loadCSV(csv:String, catalog:TileCatalog):TileChunk
  {
    var chunk = new TileChunk(catalog);
    chunk.parseCSV(csv);
    return chunk;
    // end loadCSV
  }

  //--------------------------------------------------------------------
  public function parseCSV(csv:String):Void
  {

    var col:Int, r:Int = 0;

    for (line in csv.split("\n")) {
      line = StringTools.trim(line);

      trace("Line " + line);

      col = 0;
      for (cell in line.split(",")) {
        cell = StringTools.trim(cell);

        trace("  Col " + col + " " + cell);

        var tile:Tile;
        var c = cell.charCodeAt(0);
        if (c >= "0".charCodeAt(0) &&
            c <= "9".charCodeAt(0)) {
          tile = catalog.get(Std.parseInt(cell));
        } else {
          tile = catalog.getByLabel(cell);
        }

        tiles.push(tile);

        col++;
        // end looping columns
      }

      if (columns == -1) {
        columns = col;
      } else if (col != columns) {
        Debug.error("TileChunk CSV has " + col + ", not " + columns +
                    ", columns in row " + r);
      }

      r++;
      // end looping rows
    }

    rows = r;

    #if verbose_tiles
      Debug.debug("TileChunk read " + columns + "x" + rows + " tiles");
    #end

    // end parseCSV
  }

  // end TileChunk
}
