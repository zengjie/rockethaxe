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

  private var tileCount:Int;


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

    tileCount = 0;

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
  public function addTile(x:Float, y:Float,
                          width:Float, height:Float,
                          cx:Float, cy:Float):Int
  {
    addTileRect(new Rectangle(x, y, width, height),
                new Point(cx, cy));
    tileCount++;
    return tileCount-1;
    // end addSprite
  }

  //------------------------------------------------------------
  public function getNumTiles():Int
  {
    return tileCount;
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function drawTile(x:Float, y:Float, tile:Int):Void
  {

    if (renderIndex >= blitData.length) {
      blitData.push(x);
      blitData.push(y);
      blitData.push(tile);
    } else {
      blitData[renderIndex] = x;
      blitData[renderIndex+1] = y;
      blitData[renderIndex+2] = tile;
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
