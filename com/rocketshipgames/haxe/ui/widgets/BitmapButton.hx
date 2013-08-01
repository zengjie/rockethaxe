package com.rocketshipgames.haxe.ui.widgets;

import flash.display.DisplayObjectContainer;

import flash.display.Bitmap;
import flash.display.BitmapData;

import com.rocketshipgames.haxe.gfx.widgets.DecoratedBitmap;

import com.rocketshipgames.haxe.ui.widgets.Button;


class BitmapButton
  extends Button
{

  //------------------------------------------------------------
  private var bitmap:Bitmap;

  private var upBitmap:BitmapData;
  private var overBitmap:BitmapData;
  private var downBitmap:BitmapData;
  private var disabledBitmap:BitmapData;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(action:Void->Void,
                      upBitmap:BitmapData,
                      overBitmap:BitmapData = null,
                      downBitmap:BitmapData = null,
                      disabledBitmap:BitmapData = null,
                      ?container:DisplayObjectContainer):Void
  {
    super(action, container);

    haxe.Log.trace("NEW BitmapButton");

    this.upBitmap = upBitmap;
    this.overBitmap = (overBitmap != null) ? overBitmap : upBitmap;
    this.downBitmap = (downBitmap != null) ? downBitmap : upBitmap;

    if (disabledBitmap == null)
      generateDisabledBitmap();
    else
      this.disabledBitmap = disabledBitmap;

    addChild(bitmap = new Bitmap(upBitmap));
    // end new
  }

  private function generateDisabledBitmap():Void
  {
    disabledBitmap = DecoratedBitmap.makeBitmapData
      (upBitmap,
       {redMultiplier: 0.66,
        greenMultiplier: 0.66,
        blueMultiplier: 0.66,
       });
    // end generateDisabledBitmap
  }

  public function setBitmaps(up:BitmapData,
                             over:BitmapData,
                             down:BitmapData,
                             ?disabled:BitmapData):Void
  {
    upBitmap = up;
    overBitmap = over;
    downBitmap = down;

    if (disabled == null)
      generateDisabledBitmap();
    else
      disabledBitmap = disabled;

    updateGraphicState();
    // end setBitmaps
  }

  public function setBitmap(bmp:BitmapData):Void
  {
    upBitmap = overBitmap = downBitmap = disabledBitmap = bmp;
    updateGraphicState();
    // end setBitmap
  }

  public function setUpBitmap(bmp:BitmapData):Void
  {
    upBitmap = bmp;
    updateGraphicState();
    // end setUpBitmap
  }

  public function setOverBitmap(bmp:BitmapData):Void
  {
    overBitmap = bmp;
    updateGraphicState();
    // end setOverBitmap
  }

  public function setDownBitmap(bmp:BitmapData):Void
  {
    downBitmap = bmp;
    updateGraphicState();
    // end setDownBitmap
  }

  public function setDisabledBitmap(bmp:BitmapData):Void
  {
    disabledBitmap = bmp;
    updateGraphicState();
    // end setDownBitmap
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private override function updateGraphicState():Void
  {
    switch (state) {
    case UP:
      bitmap.bitmapData = upBitmap;

    case OVER:
      bitmap.bitmapData = overBitmap;

    case DOWN:
      bitmap.bitmapData = downBitmap;

    case DISABLED:
      bitmap.bitmapData = disabledBitmap;
    }
    // end updateGraphicState
  }

  // end BitmapButton
}
