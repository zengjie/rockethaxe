package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.component.CapabilityID;

import com.rocketshipgames.haxe.debug.Debug;


class GameSprite
  extends FrameCatalog
{


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

    // end new
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


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function create(?tag:CapabilityID):GameSpriteComponent
  {
    var x = new GameSpriteComponent(this, tag);
    return x;
    // end create
  }

  // end SpriteCatalog
}
