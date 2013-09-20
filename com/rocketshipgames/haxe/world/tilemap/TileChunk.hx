package com.rocketshipgames.haxe.world.tilemap;

import com.rocketshipgames.haxe.debug.Debug;


class TileChunk
  implements com.rocketshipgames.haxe.physics.Extent2D
{

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
  public function left():Float   { return x; }
  public function right():Float  { return x + (columns * catalog.width); }
  public function top():Float    {return y; }
  public function bottom():Float { return y + (rows * catalog.height); }

  public function tile(col:Int, row:Int):Tile
  {
    return tiles[(row*columns)+col];
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function loadCSV(catalog:TileCatalog, csv:String):TileChunk
  {
    var chunk = new TileChunk(catalog);
    chunk.parseCSV(csv);
    return chunk;
    // end loadCSV
  }

  //--------------------------------------------------------------------
  public function parseCSV(csv:String):Void
  {
    csv = StringTools.trim(csv);

    var col:Int, r:Int = 0;

    var map = new Array<Array<Int>>();

    for (line in csv.split("\n")) {
      line = StringTools.trim(line);

      map[r] = new Array<Int>();

      col = 0;
      for (cell in line.split(",")) {
        cell = StringTools.trim(cell);

        var tile:Tile;
        var c = cell.charCodeAt(0);
        if (c >= "0".charCodeAt(0) &&
            c <= "9".charCodeAt(0)) {
          map[r][col] = Std.parseInt(cell);
          //          tile = catalog.get(Std.parseInt(cell));
        } else {
          //          tile = catalog.getByLabel(cell);
        }

        /*
        if (tile == null) {
          Debug.error("Tile referenced by '" + cell + "' line " + r + 
                      " column " + col + " was null.");
        } else
          tiles.push(tile);
        */

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

    var tile:Tile;
    var bit:Int;

    var bits = new Array<Array<Int>>();

    for (row in 0...rows) {
      bits[row] = new Array<Int>();
      for (col in 0...columns) {
        bits[row][col] = map[row][col];
      }
    }

    /*
    for (row in 0...rows) {
      for (col in 0...columns) {
        if (map[row][col] != 0) {
          var index = 0;
          if (map[row][col] > 1)
            index = 16 << (map[row][col]-2);

          if (row > 0) {
            if (col > 0) bits[row-1][col-1] |= 8|index;
            bits[row-1][col] |= 4|8|index;
            if (col < columns-1) bits[row-1][col+1] |= 4|index;
          }

          if (col > 0) bits[row][col-1] |= 2|8|index;
          bits[row][col] |= 15|index;
          if (col < columns-1) bits[row][col+1] |= 1|4|index;

          if (row < rows-1) {
            if (col > 0) bits[row+1][col-1] |= 2|index;
            bits[row+1][col] |= 1|2|index;
            if (col < columns-1) bits[row+1][col+1] |= 1|index;
          }

        }

        // end looping columns
      }
    }
    */

    for (row in 0...rows) {
      for (col in 0...columns) {


        tile = catalog.get(bits[row][col]);

        if (tile == null) {
          Debug.error("Tile referenced by '" + map[row][col] + "' line " + r + 
                      " column " + col + " was null.");
        } else
          tiles.push(tile);

      }
    }

    // end parseCSV
  }

  // end TileChunk
}
