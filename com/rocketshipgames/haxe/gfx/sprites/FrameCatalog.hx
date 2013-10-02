package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.debug.Debug;


class FrameCatalog
{

  public var spritesheet(default,null):SpritesheetContainer;
  public var baseFrameIndex(default,null):Int;
  public var frameCount(default,null):Int;

  public var title(default,null):String;

  public var pixelWidth(default,null):Int;
  public var pixelHeight(default,null):Int;



  //----------------------------------------------------
  private var keyframes:Map<String, Int>;

  private var defaultCentered:Bool;


  //--------------------------------------------------------------------
  public function new(spritesheet:SpritesheetContainer):Void
  {

    this.spritesheet = spritesheet;
    this.title = "unnamed";

    keyframes = new Map();

    // end new
  }

  public function keyframe(label:String):Int
  {
    var f:Int = keyframes.get(label);
    if (f == 0)
      f = baseFrameIndex;
    return f;
  }

  //--------------------------------------------------------------------
  private function extractFrames(root:haxe.xml.Fast):Void
  {

    // Need to base any raw numbers off the first tile extracted by
    // this catalog, NOT the zero-th tile for the spritesheet---other
    // sprites may have been loaded beforehand.
    baseFrameIndex = spritesheet.getFrameCount();

    for (cmd in root.elements) {

      commandSwitch(cmd);

      // end looping frame commands
    }

    // end extractFrames
  }

  //----------------------------------------------------
  private function commandSwitch(cmd:haxe.xml.Fast):Void
  {

      if (cmd.name == "grid")
        parseGrid(cmd);
      else if (cmd.name == "keyframe")
        parseKeyframe(cmd);
      else
        Debug.error("Unknown frame catalog command " + cmd.name);

    // end commandSwitch
  }

  //----------------------------------------------------
  private function parseGrid(cmd:haxe.xml.Fast):Void
  {

    if (cmd.has.label)
      keyframes.set(cmd.att.label, spritesheet.getFrameCount());

    var columns:Int = 1;
    var rows:Int = 1;
    if (cmd.has.columns) columns = Std.parseInt(cmd.att.columns);
    if (cmd.has.rows) rows = Std.parseInt(cmd.att.rows);

    var basex:Int = 0;
    if (cmd.has.x) basex = Std.parseInt(cmd.att.x);

    var basey:Int = 0;
    if (cmd.has.y) basey = Std.parseInt(cmd.att.y);


    var cx:Float = 0.0, cy:Float = 0.0;
    if (defaultCentered) {
      cx = pixelWidth/2;
      cy = pixelHeight/2;
    }

    var x:Int = basex;
    var y:Int = basey;
    for (r in 0...rows) {
      x = basex;

      for (c in 0...columns) {
        spritesheet.addFrame(x, y, pixelWidth, pixelHeight, cx, cy);
        frameCount++;
        x += pixelWidth;
        // end columns
      }

      y += pixelHeight;
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

    keyframes.set(cmd.att.label, frame);

    #if (verbose_tiles || verbose_sprites)
      Debug.debug("  Keyframe " +  cmd.att.label + " frame " + frame);
    #end

    // end parseKeyframe
  }


  // end FrameCatalog
}
