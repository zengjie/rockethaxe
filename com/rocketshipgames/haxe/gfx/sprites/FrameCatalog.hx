package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.debug.Debug;


class FrameCatalog
{

  public var spritesheet(default,null):SpritesheetContainer;
  public var frameCount(default,null):Int;

  public var title(default,null):String;

  //----------------------------------------------------
  private var frameLabels:Map<String, Int>;

  private var baseFrameIndex:Int;


  //--------------------------------------------------------------------
  public function new(spritesheet:SpritesheetContainer):Void
  {

    this.spritesheet = spritesheet;
    this.title = "unnamed";

    frameLabels = new Map();

    // end new
  }


  //--------------------------------------------------------------------
  private function extractFrames(root:haxe.xml.Fast, width:Int, height:Int):Void
  {

    // Need to base any raw numbers off the first tile extracted by
    // this catalog, NOT the zero-th tile for the spritesheet---other
    // sprites may have been loaded beforehand.
    baseFrameIndex = spritesheet.getFrameCount();

    for (cmd in root.elements) {

      if (cmd.name == "grid")
        parseGrid(cmd, width, height);
      else if (cmd.name == "keyframe")
        parseKeyframe(cmd);

      // end looping frame commands
    }

    // end extractFrames
  }

  //----------------------------------------------------
  private function parseGrid(cmd:haxe.xml.Fast, width:Int, height:Int):Void
  {

    if (cmd.has.label)
      frameLabels.set(cmd.att.label, spritesheet.getFrameCount());

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

    #if (verbose_tiles || verbose_sprites)
      Debug.debug("  Grid " + columns + "x" + rows +
                  " from " + basex + "," + basey);
    #end

    // end parseGrid
  }

  private function parseKeyframe(cmd:haxe.xml.Fast):Void
  {
    if (!cmd.has.label) {
      Debug.error("Keyframe does not have a label.");
      return;
    }

    var frame:Int = spritesheet.getFrameCount();
    if (cmd.has.frame) frame = baseFrameIndex + Std.parseInt(cmd.att.frame);

    frameLabels.set(cmd.att.label, frame);

    #if (verbose_tiles || verbose_sprites)
      Debug.debug("  Keyframe " +  cmd.att.label + " frame " + frame);
    #end

    // end parseKeyframe
  }


  // end FrameCatalog
}
