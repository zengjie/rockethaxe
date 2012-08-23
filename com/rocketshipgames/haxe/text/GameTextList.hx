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

package com.rocketshipgames.haxe.text;

import nme.display.BitmapData;

import com.rocketshipgames.haxe.text.HorizontalJustification;
import com.rocketshipgames.haxe.text.VerticalJustification;

import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;
import com.rocketshipgames.haxe.gfx.GrowthDirection;


class GameTextList
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer,
  implements TextReceiver
{

  //------------------------------------------------------------
  public static inline var DEFAULT_DURATION:Int = 5000;
  public static inline var DEFAULT_WAIT:Int = 0;
  public static inline var DEFAULT_FADEIN:Int = 0;
  public static inline var DEFAULT_FADEOUT:Int = 0;

  public static inline var
    DEFAULT_HORIZONTAL_JUSTIFICATION:HorizontalJustification = LEFT;
  public static inline var
    DEFAULT_VERTICAL_JUSTIFICATION:VerticalJustification = TOP;

  public static inline var
    DEFAULT_HORIZONTAL_ALIGNMENT:HorizontalAlignment = LEFT;
  public static inline var
    DEFAULT_VERTICAL_ALIGNMENT:VerticalAlignment = TOP;

  public static inline var
    DEFAULT_GROWTH_DIRECTION:GrowthDirection = FORWARD;

  public var defaultDuration:Int;
  public var defaultWait:Int;
  public var defaultFadeIn:Int;
  public var defaultFadeOut:Int;

  public var predecorator:BitmapData->Void = null;
  public var postdecorator:BitmapData->Void = null;

  public var defaultOpts:Dynamic = null;

  public var verticalJustification:VerticalJustification;
  public var horizontalJustification:HorizontalJustification;

  public var defaultVerticalAlignment:VerticalAlignment;
  public var defaultHorizontalAlignment:HorizontalAlignment;

  public var growthDirection:GrowthDirection;

  public var onEmptyList:GameTextList->Void;

  //------------------------------------------------------------
  private var texts:List<GameText> = null;

  private var last:GameText;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    texts = new List();

    defaultDuration = DEFAULT_DURATION;
    defaultWait = DEFAULT_WAIT;
    defaultFadeIn = DEFAULT_FADEIN;
    defaultFadeOut = DEFAULT_FADEOUT;

    growthDirection = DEFAULT_GROWTH_DIRECTION;

    verticalJustification = DEFAULT_VERTICAL_JUSTIFICATION;
    horizontalJustification = DEFAULT_HORIZONTAL_JUSTIFICATION;

    defaultVerticalAlignment = DEFAULT_VERTICAL_ALIGNMENT;
    defaultHorizontalAlignment = DEFAULT_HORIZONTAL_ALIGNMENT;

    onEmptyList = null;

    defaultOpts = null;

    last = null;

    // end new
  }

  //------------------------------------------------------------
  public function receiveText(text:String, opts:Dynamic=null):Void
  {

    if (opts != null) {
      if (defaultOpts != null) {
        for (i in Reflect.fields(defaultOpts)) {
          if (!Reflect.hasField(opts, i)) {
            Reflect.setField(opts, i, Reflect.field(defaultOpts, i));
          }
        }
      }
    } else {
      opts = Reflect.copy(defaultOpts);
    }

    last = newGameText(this, text, opts, predecorator, postdecorator);

    if (growthDirection == FORWARD)
      texts.add(last);
    else
      texts.push(last);

    // end receiveText
  }

  private function remove(text:GameText)
  {
    if (last == text)
      last = null;
    texts.remove(text);
    if (onEmptyList != null && texts.length == 0)
      onEmptyList(this);
    // end remove
  }

  /*
   * This is here to override to use an extended GameText class.
   */
  private function newGameText(list:GameTextList,
                               text:String, opts:Dynamic=null,
                               predecorator:BitmapData->Void = null,
                               postdecorator:BitmapData->Void = null):GameText
  {
    return new GameText(list, text, opts, predecorator, postdecorator);
    // end newGameText
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function render(graphics:nme.display.Graphics, elapsed:Int):Void
  {
    for (lt in texts)
      if (lt.update(elapsed))
        remove(lt);
    // end render
  }

  // end GameTextList
}
