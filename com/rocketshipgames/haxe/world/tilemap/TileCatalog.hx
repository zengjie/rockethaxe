package com.rocketshipgames.haxe.world.tilemap;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;


class TileCatalog
{

  public var spritesheet(default,null):SpritesheetContainer;
  public var frameCount(default,null):Int;

  public var label(default,null):String;
  public var width(default,null):Int;
  public var height(default,null):Int;

  //----------------------------------------------------
  private var tiles:Array<Tile>;

  private var tileIndex:Int;


  //--------------------------------------------------------------------
  public function new(spritesheet:SpritesheetContainer):Void
  {
    this.spritesheet = spritesheet;
    this.label = "unnamed";
    tiles = new Array();
    // end new
  }

  public static function load(descriptor:String,
                              spritesheet:SpritesheetContainer):TileCatalog
  {
    var catalog = new TileCatalog(spritesheet);
    catalog.parse(descriptor);
    return catalog;
    // end TileCatalog
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function get(tile:Int):Tile
  {
    return tiles[tile];
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function parse(descriptor:String):Void
  {

    var root = new haxe.xml.Fast(Xml.parse(descriptor).firstElement());

    //-- Get the basic properties, namely width and height
    if (root.has.label) label = root.att.label;

    if (root.has.width)
      width = Std.parseInt(root.att.width);
    else
      Debug.error("Tilesheet has no tile width.");

    if (root.has.height)
      height = Std.parseInt(root.att.height);
    else
      Debug.error("Tilesheet has no tile height.");

    #if verbose_tiles
      Debug.debug("Tileset " + label + " w,h " + width + "," + height);
    #end

    //-- Populate frames
    for (frames in root.nodes.frames) {
      for (cmd in frames.elements) {

        if (cmd.name == "grid")
          parseGrid(cmd);

        // end looping frame commands
      }
      // end iterating frames groups
    }

    //-- Populate tiles
    for (tiles in root.nodes.tiles) {
      for (cmd in tiles.elements) {
        if (cmd.name == "tile") {
          parseTile(cmd);
        }
      }
      // end iterating tiles groups
    }

    // end parse
  }

  //----------------------------------------------------
  private function parseGrid(cmd:haxe.xml.Fast):Void
  {

    var columns:Int = 1;
    var rows:Int = 1;
    if (cmd.has.columns) columns = Std.parseInt(cmd.att.columns);
    if (cmd.has.rows) rows = Std.parseInt(cmd.att.rows);

    var basex:Int = 0;
    if (cmd.has.x) basex = Std.parseInt(cmd.att.x);

    var basey:Int = 0;
    if (cmd.has.y) basey = Std.parseInt(cmd.att.y);

    var x:Int = basex;
    var y:Int = basey;
    for (r in 0...rows) {
      x = basex;

      for (c in 0...columns) {
        spritesheet.addFrame(x, y, width, height, 0, 0);
        x += width;
        // end columns
      }

      y += height;
      // end rows
    }

    #if verbose_tiles
      Debug.debug("  Added " + columns + "x" + rows +
                  " grid from " + basex + "," + basey);
    #end
    // end parseGrid
  }

  //----------------------------------------------------
  private function parseTile(cmd:haxe.xml.Fast):Void
  {

    var label:String = null;
    if (cmd.has.label) label = cmd.att.label;

    var frame:Int = tileIndex;
    if (cmd.has.frame) frame = Std.parseInt(cmd.att.frame);

    var collidesAs:Int = 0;
    if (cmd.has.collides) collidesAs = Std.parseInt(cmd.att.collides);

    tiles.push(new Tile(frame, collidesAs, label));
    tileIndex = frame+1; // Continue from this tile if manually set

    // end parseTile
  }

  // end TileCatalog
}
