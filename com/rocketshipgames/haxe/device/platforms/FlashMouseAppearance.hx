package com.rocketshipgames.haxe.device.platforms;

import openfl.Assets;

import flash.Vector;

import flash.geom.Point;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;

import com.rocketshipgames.haxe.device.Mouse;

class FlashMouseAppearance
  implements MouseAppearanceWrapper
{

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
    setCursor(cursor, hotspotX, hotspotY);
    // end enable
  }

  public function disable():Void
  {
    flash.ui.Mouse.cursor = MouseCursor.AUTO;
    flash.ui.Mouse.hide();
    // end disable
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function updateVisibility(visibility:Bool):Void
  {
    if (visibility)
      flash.ui.Mouse.show();
    else
      flash.ui.Mouse.hide();
    // end updateVisibility
  }

  //------------------------------------------------------------
  public function updatePosition(x:Float, y:Float):Void
  {
    // end updatePosition
  }

  //------------------------------------------------------------
  public function idleOut():Void
  {
    flash.ui.Mouse.hide();
    // end idleOut
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function setCursor(?asset:String=null,
                            ?hotspotX:Float=0, ?hotspotY:Float=0):Void
  {
    if (asset == null) {
      asset = Mouse.CURSOR_POINTER;
    }

    var cursorData:MouseCursorData = new MouseCursorData();
    cursorData.hotSpot = new Point(hotspotX, hotspotY);
    var bitmaps:Vector<BitmapData> = new Vector();
    bitmaps[0] = Assets.getBitmapData(asset);
    cursorData.data = bitmaps;

    flash.ui.Mouse.registerCursor(asset, cursorData);
    flash.ui.Mouse.cursor = asset;
    // end setCursor
  }

  // end FlashMouseAppearance
}
