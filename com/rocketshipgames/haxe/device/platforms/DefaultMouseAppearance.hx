package com.rocketshipgames.haxe.device.platforms;

import openfl.Assets;

import flash.display.Bitmap;
import flash.display.BitmapData;

import motion.Actuate;

import com.rocketshipgames.haxe.device.Mouse;

class DefaultMouseAppearance
  implements MouseAppearanceWrapper
{

  private var cursor:Bitmap;
  private var hotspotX:Float;
  private var hotspotY:Float;

  private var fading:Bool;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function enable(?cursor:String, ?hotspotX:Float, ?hotspotY:Float):Void
  {
    this.cursor = new Bitmap();
    this.cursor.visible = false;
    this.hotspotX = 0;
    this.hotspotY = 0;

    fading = false;

    setCursor(cursor, hotspotX, hotspotY);

    flash.Lib.current.stage.addChild(this.cursor);
    // end enable
  }

  public function disable():Void
  {
    if (flash.Lib.current.stage.contains(cursor))
      flash.Lib.current.stage.removeChild(cursor);
    // end disable
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function updateVisibility(visibility:Bool):Void
  {
    cursor.visible = visibility;
    if (visibility) {
      if (fading) {
        Actuate.stop(cursor, {alpha: null}, false, false);
        fading = false;
      }
      cursor.alpha = 1;
    }
    // end updateVisibility
  }

  //------------------------------------------------------------
  public function updatePosition(x:Float, y:Float):Void
  {
    cursor.x = x - hotspotX;
    cursor.y = y - hotspotY;
    // end updatePosition
  }

  //------------------------------------------------------------
  public function idleOut():Void
  {
    fading = true;
    Actuate.tween(cursor, 1, {alpha: 0});
    // end idleOut
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function setCursor(?asset:String=null,
                            ?hotspotX:Float=0, ?hotspotY:Float=0):Void
  {
    if (asset == null)
      cursor.bitmapData = Assets.getBitmapData(Mouse.CURSOR_POINTER);
    else
      cursor.bitmapData = Assets.getBitmapData(asset);

    cursor.x += this.hotspotX;
    cursor.y += this.hotspotY;

    this.hotspotX = hotspotX;
    this.hotspotY = hotspotY;

    cursor.x -= this.hotspotX;
    cursor.y -= this.hotspotY;
    // end setCursor
  }

  // end DefaultMouseAppearance
}
