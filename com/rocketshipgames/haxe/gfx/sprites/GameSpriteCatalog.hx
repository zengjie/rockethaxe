package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.debug.Debug;


class GameSpriteCatalog
{

  public var spritesheet(default,null):SpritesheetContainer;

  public var title:String;

  //--------------------------------------------------------------------
  private var sprites:Map<String, GameSprite>;

  //--------------------------------------------------------------------
  public function new(spritesheet:SpritesheetContainer):Void
  {
    this.spritesheet = spritesheet;

    title ="unnamed";

    sprites = new Map();

    // end new
  }

  public static function load(descriptor:String,
                              spritesheet:SpritesheetContainer):GameSpriteCatalog
  {
    var x = new GameSpriteCatalog(spritesheet);
    x.parse(descriptor);
    return x;
    // end load
  }

  public function get(label:String):GameSprite
  {
    return sprites.get(label);
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function parse(descriptor:String):Void
  {
    var root = new haxe.xml.Fast(Xml.parse(descriptor).firstElement());

    if (root.has.title) title = root.att.title;

    #if verbose_sprites
      Debug.debug("Spriteset " + title);
    #end

    for (sprite in root.nodes.sprite) {
      parseSprite(sprite);
    }

    // end parse
  }

  //----------------------------------------------------
  public function parseSprite(xml:haxe.xml.Fast):Void
  {

    var label:String = "unnamed";
    if (xml.has.label)
      label = xml.att.label;
    else
      Debug.error("Sprite has no label.");

    var pixelWidth:Int = 0, pixelHeight:Int = 0;

    if (xml.has.pixelWidth)
      pixelWidth = Std.parseInt(xml.att.pixelWidth);
    else
      Debug.error("Sprite " + label + " has no pixelWidth.");

    if (xml.has.pixelHeight)
      pixelHeight = Std.parseInt(xml.att.pixelHeight);
    else
      Debug.error("Sprite " + label + " has no pixelHeight.");

    #if verbose_sprites
      Debug.debug(" Sprite " + label + " " + pixelWidth + "," + pixelHeight);
    #end

    sprites.set(label, GameSprite.populate(spritesheet,
                                           label,
                                           pixelWidth, pixelHeight,
                                           xml));

    // end parseSprite
  }

  // end GameSpriteCatalog
}
