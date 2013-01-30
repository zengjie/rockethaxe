/*
 * Copyright (c) 2012, 2013 Joe Kopena <tjkopena@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.rocketshipgames.haxe.gfx;

import nme.display.BitmapData;


class GameSpriteContainer
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer
{

  private var spritesheetContainer:SpritesheetContainer;
  private var gameSpriteRenderer:GameSpriteRenderer;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(spritesheet:BitmapData, descriptor:String):Void
  {

    spritesheetContainer = new SpritesheetContainer(spritesheet);
    gameSpriteRenderer =
      new GameSpriteRenderer(spritesheetContainer, descriptor);

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function getNumInstances():Int
  {
    return gameSpriteRenderer.getNumInstances();
    // end getNumInstances
  }

  //------------------------------------------------------------
  public function getSprite(name:String)
  {
    return gameSpriteRenderer.getSprite(name);
    // end getSprite
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function addInstance(sprite:GameSpriteInstance, layer:Int=0):Void
  {
    gameSpriteRenderer.addInstance(sprite, layer);
    // end addInstance
  }

  public function removeInstance(sprite:GameSpriteInstance):Void
  {
    gameSpriteRenderer.removeInstance(sprite);
    // end function removeInstance
  }

  public function relayerInstance(sprite:GameSpriteInstance, layer:Int=0):Void
  {
    gameSpriteRenderer.relayerInstance(sprite, layer);
    // end function relayerInstance
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(graphics:nme.display.Graphics, elapsed:Int):Void
  {
    spritesheetContainer.render(graphics, elapsed);
    // end render
  }

  // end GameSpriteContainer
}
