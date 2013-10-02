package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.component.CapabilityID;

import com.rocketshipgames.haxe.debug.Debug;


class GameSprite
  extends FrameCatalog
{

  //----------------------------------------------------
  private var animations:Map<String, GameSpriteAnimation>;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(spritesheet:SpritesheetContainer,
                      label:String,
                      pixelWidth:Int, pixelHeight:Int):Void
  {
    super(spritesheet);

    title = label;

    this.pixelWidth = pixelWidth;
    this.pixelHeight = pixelHeight;

    defaultCentered = true;

    animations = new Map();

    // end new
  }

  //----------------------------------------------------
  public function create(?tag:CapabilityID):GameSpriteComponent
  {
    var x = new GameSpriteComponent(this, tag);
    return x;
    // end create
  }

  public function animation(label:String):GameSpriteAnimation
  {
    if (!animations.exists(label)) {
      Debug.error("Unknown animation " + label + " in sprite " + title);
    }

    return animations.get(label);
    // end animation
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function populate(spritesheet:SpritesheetContainer,
                                  label:String,
                                  pixelWidth:Int, pixelHeight:Int,
                                  xml:haxe.xml.Fast):GameSprite
  {
    var x = new GameSprite(spritesheet, label, pixelWidth, pixelHeight);
    x.extractFrames(xml);
    return x;
    // end populate
  }

  //----------------------------------------------------
  public override function commandSwitch(cmd:haxe.xml.Fast):Void
  {

    if (cmd.name == "animation")
      parseAnimation(cmd);
    else
      super.commandSwitch(cmd);

    // end commandSwitch
  }

  //----------------------------------------------------
  public function parseAnimation(cmd:haxe.xml.Fast):Void
  {

    if (!cmd.has.label) {
      Debug.error("Animation in sprite " + title + " is missing a label.");
      return;
    }

    var anim = new GameSpriteAnimation(cmd.att.label);
    animations.set(anim.label, anim);

    if (cmd.has.loop && cmd.att.loop != 'false') {
      anim.loop = true;
    }

    #if (verbose_sprites)
      Debug.debug("  Animation " + anim.label + " " +
                  ((anim.loop)?"(loop)":""));
    #end

    for (animcmd in cmd.elements) {
      switch (animcmd.name) {

      case "sequence":
        var start:Int = baseFrameIndex;
        if (animcmd.has.start) {
          var c = animcmd.att.start.charCodeAt(0);
          if (c >= "0".charCodeAt(0) &&
              c <= "9".charCodeAt(0)) {
            start = baseFrameIndex + Std.parseInt(animcmd.att.start);
          } else {
            start = keyframe(animcmd.att.start);
          }
        }

        var end:Int = baseFrameIndex;
        if (animcmd.has.end) {
          var c = animcmd.att.end.charCodeAt(0);
          if (c >= "0".charCodeAt(0) &&
              c <= "9".charCodeAt(0)) {
            end = baseFrameIndex + Std.parseInt(animcmd.att.end);
          } else {
            end = keyframe(animcmd.att.end);
          }
        } else if (animcmd.has.count) {
          end = start + Std.parseInt(animcmd.att.count);
        }

        var interval:Int = GameSpriteAnimation.DEFAULT_INTERVAL;
        if (animcmd.has.interval)
          interval = Std.parseInt(animcmd.att.interval);

        var fm:Int = start;
        while (fm < end) {
          anim.add(fm, interval);
          fm++;
        }

        #if (verbose_sprites)
          Debug.debug("    Sequence " + start + "--" + end + ":" + interval);
        #end

        // end sequence

      case "cell":
        var fm:Int = baseFrameIndex;
        if (animcmd.has.frame) {
          var c = animcmd.att.frame.charCodeAt(0);
          if (c >= "0".charCodeAt(0) &&
              c <= "9".charCodeAt(0)) {
            fm = baseFrameIndex + Std.parseInt(animcmd.att.frame);
          } else {
            fm = keyframe(animcmd.att.frame);
          }
        }

        var interval:Int = GameSpriteAnimation.DEFAULT_INTERVAL;
        if (animcmd.has.interval)
          interval = Std.parseInt(animcmd.att.interval);

        anim.add(fm, interval);

        #if (verbose_sprites)
          Debug.debug("    Cell " + fm + ":" + interval);
        #end

        // end cell
      }

      // end looping animation commands
    }


    // end parseAnimation
  }

  // end SpriteCatalog
}
