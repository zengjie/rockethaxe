/*
 * Copyright (c) 2012 Joe Kopena <tjkopena@gmail.com>
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

package com.rocketshipgames.haxe.gfx.widgets;

import com.rocketshipgames.haxe.gfx.GameSprite;
import com.rocketshipgames.haxe.gfx.GameSpriteContainer;
import com.rocketshipgames.haxe.gfx.GameSpriteInstance;

import com.rocketshipgames.haxe.gfx.widgets.PercentBar;

class GameSpritePercentBar
  extends PercentBar<GameSpriteInstancePercentBarGraphic>
{

  //------------------------------------------------------------
  private var container:GameSpriteContainer;
  private var layer:Int;

  private var sprite:GameSprite;
  private var frameFunction:Int->Int->Int;
  private var enabledFrame:Int;
  private var disabledFrame:Int;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:GameSpriteContainer, layer:Int,
                      sprite:GameSprite,
                      x:Float,
                      y:Float,
                      maxValue:Float,
                      numBars:Int,
                      enabledFrame:Int,
                      disabledFrame:Int,
                      opts:Dynamic,
                      frameFunction:Int->Int->Int = null):Void
  {
    this.container = container;
    this.layer = layer;
    this.sprite = sprite;

    if (enabledFrame == -1)
      this.enabledFrame = sprite.baseIndex;
    else
      this.enabledFrame = enabledFrame;

    this.disabledFrame = disabledFrame;
    this.frameFunction = frameFunction;

    super(x, y, maxValue, numBars, opts);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private override function graphicWidth():Float { return sprite.width; }
  private override function graphicHeight():Float { return sprite.height; }

  private override function newGraphic(position:Int):GameSpriteInstancePercentBarGraphic
  {
    return new GameSpriteInstancePercentBarGraphic(container, layer, sprite);
    // end newGraphic
  }

  private override function setEnabledGraphic
    (g:GameSpriteInstancePercentBarGraphic, position:Int):Void
  {
    if (frameFunction != null) {
      if ((g.frame = frameFunction(position, drawBars)) == -1)
        g.visible = false;
      else
        g.visible = visible;
    } else {
      g.visible = visible;
      g.frame = enabledFrame;
    }
    // end setEnabledGraphic
  }

  private override function setDisabledGraphic
    (g:GameSpriteInstancePercentBarGraphic, position:Int):Void
  {
    if ((g.frame = disabledFrame) == -1)
      g.visible = false;
    else
      g.visible = visible;
    // end setDisabledGraphic
  }

  // end GameSpritePercentBar
}

private class GameSpriteInstancePercentBarGraphic
  extends GameSpriteInstance,
  implements PercentBarGraphic
{

  public function new(container:GameSpriteContainer, layer:Int,
                      sprite:GameSprite):Void
  {
    super(container, layer, sprite);
    // end new
  }

  // end GameSpriteInstancePercentBarGraphic
}
