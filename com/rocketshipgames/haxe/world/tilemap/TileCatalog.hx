package com.rocketshipgames.haxe.world.tilemap;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.gfx.sprites.FrameCatalog;
import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;


/**
 * The XML format parsed by the TileCatalog is described here:
 *   https://code.google.com/p/rockethaxe/wiki/TileCatalog
 */


class TileCatalog
  extends FrameCatalog
{

  public var width(default,null):Int;
  public var height(default,null):Int;

  //----------------------------------------------------
  private var tiles:Array<Tile>;

  private var tileLabels:Map<String, Tile>;

  private var collisionTags:Map<String, Int>;
  private var collisionBitmask:Int;

  private var tileIndex:Int;


  //--------------------------------------------------------------------
  public function new(spritesheet:SpritesheetContainer):Void
  {
    super(spritesheet);

    tiles = new Array();

    tileLabels = new Map();

    collisionTags = new Map();
    collisionBitmask = 0;

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

  public function getByLabel(tile:String):Tile
  {
    return tileLabels.get(tile);
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function parse(descriptor:String):Void
  {

    var root = new haxe.xml.Fast(Xml.parse(descriptor).firstElement());

    //-- Get the basic properties, namely width and height
    if (root.has.title) title = root.att.title;

    if (root.has.width)
      width = Std.parseInt(root.att.width);
    else
      Debug.error("Tilesheet has no tile width.");

    if (root.has.height)
      height = Std.parseInt(root.att.height);
    else
      Debug.error("Tilesheet has no tile height.");

    #if verbose_tiles
      Debug.debug("Tileset " + title + " w,h " + width + "," + height);
    #end


    //-- Populate collision tags
    for (tags in root.nodes.collisionTags) {
      parseCollisionTags(tags);
    }

    //-- Populate frames
    for (frames in root.nodes.frames) {
      extractFrames(frames, width, height);
    }

    //-- Populate tiles
    tileIndex = baseFrameIndex;
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
  private function parseCollisionTags(cmd:haxe.xml.Fast):Void
  {
    var bitmask:Int;

    for (tag in cmd.elements) {

      bitmask = collisionBitmask;
      if (tag.has.code) bitmask = Std.parseInt(tag.att.code);

      collisionTags.set(tag.name, bitmask);

      #if verbose_tiles
        Debug.debug("Collision group " + tag.name + " = " + bitmask);
      #end

      if (bitmask == 0)
        collisionBitmask = 1;
      else
        collisionBitmask = bitmask*2;

      // end looping tags
    }
    // end parseCollisionGroups
  }


  //----------------------------------------------------
  private function parseTile(cmd:haxe.xml.Fast):Void
  {

    var label:String = null;
    if (cmd.has.label) label = cmd.att.label;

    var frame:Int = tileIndex;
    if (cmd.has.frame) {
      if (cmd.att.frame == "clear") {
        frame = -1;
      } else {
        var c = cmd.att.frame.charCodeAt(0);
        if (c >= "0".charCodeAt(0) &&
            c <= "9".charCodeAt(0)) {
          frame = baseFrameIndex + Std.parseInt(cmd.att.frame);
        } else {
          frame = frameLabels.get(cmd.att.frame);
        }
      }
    }

    var collidesAs:Int = 0;
    if (cmd.has.collision) {
      for (t in cmd.att.collision.split(",")) {
        var c = t.charCodeAt(0);
        if (c >= "0".charCodeAt(0) &&
            c <= "9".charCodeAt(0)) {
          collidesAs |= Std.parseInt(t);
        } else {
          collidesAs |= collisionTags.get(StringTools.trim(t));
        }
      }
    }

    #if verbose_tiles
      Debug.debug("  Tile " +  label + " frame " + frame +
                  " collidesAs " + collidesAs);
    #end

    var tile = new Tile(frame, collidesAs, label);
    tiles.push(tile);

    if (tile.label != null)
      tileLabels.set(label, tile);

    tileIndex = frame+1; // Continue from this tile if manually set

    // end parseTile
  }

  // end TileCatalog
}
