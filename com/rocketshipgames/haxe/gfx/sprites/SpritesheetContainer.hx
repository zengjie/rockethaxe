package com.rocketshipgames.haxe.gfx.sprites;

import flash.geom.Rectangle;
import flash.geom.Point;

import flash.display.BitmapData;
import openfl.display.Tilesheet;

import com.rocketshipgames.haxe.debug.Debug;


class SpritesheetContainer 
  extends Tilesheet
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer
{

  //--------------------------------------------------------------------
  private var blitData:Array<Float>;

  private var renderIndex:Int;

  private var renderers:Array<SpritesheetRenderer>;

  private var frameCount:Int;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(spritesheet:BitmapData):Void
  {
    if (spritesheet == null) {
      Debug.error("SpritesheetContainer must be given spritesheet BitmapData.");
      return;
    }

    super(spritesheet);

    blitData = new Array();

    renderers = new Array();

    frameCount = 0;

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addRenderer(r:SpritesheetRenderer):Void
  {
    renderers.push(r);
    r.attach(this);
    // end addRenderer
  }

  //------------------------------------------------------------
  public function addFrame(x:Float, y:Float,
                           width:Float, height:Float,
                           cx:Float, cy:Float):Int
  {
    addTileRect(new Rectangle(x, y, width, height),
                new Point(cx, cy));
    frameCount++;
    return frameCount-1;
    // end addSprite
  }

  //------------------------------------------------------------
  public function getNumFrames():Int
  {
    return frameCount;
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function drawFrame(x:Float, y:Float, frame:Int):Void
  {

    if (renderIndex >= blitData.length) {
      blitData.push(x);
      blitData.push(y);
      blitData.push(frame);
    } else {
      blitData[renderIndex] = x;
      blitData[renderIndex+1] = y;
      blitData[renderIndex+2] = frame;
    }

    renderIndex += 3;

    // end drawSprite
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function render(graphics:flash.display.Graphics,
                         viewport:com.rocketshipgames.haxe.gfx.Viewport):Void
  {

    renderIndex = 0;
    for (r in renderers) {
      r.render(viewport);
    }

    if (renderIndex < blitData.length) {
      blitData.splice(renderIndex, blitData.length-renderIndex);
    }

    drawTiles(graphics, blitData);

    // end render
  }

  // end SpritesheetContainer
}
