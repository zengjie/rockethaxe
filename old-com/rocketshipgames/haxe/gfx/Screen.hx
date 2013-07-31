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

package com.rocketshipgames.haxe.gfx;

import nme.display.StageAlign;
import nme.display.StageScaleMode;


class Screen
{

  public static var width(default,null):Float;
  public static var height(default,null):Float;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function configure(align:StageAlign, scale:StageScaleMode):Void
  {
    nme.Lib.current.stage.align = align;
    nme.Lib.current.stage.scaleMode = scale;

    /*
     * This little oddity is to account for the fact that the
     * standalone Flash player starts at some default window size, and
     * then adjust to your requested stage size.  If you poll
     * stageWidth/stageHeight too early, before it does that, you'll
     * get funny values.  However, the loaderInfo width and height are
     * always correct.  Unfortunately, the Android target doesn't have
     * width and height properties on all the objects...
     */

    #if flash
      width = nme.Lib.current.loaderInfo.width;
      height = nme.Lib.current.loaderInfo.height;
    #else
      width = nme.Lib.current.stage.stageWidth;
      height = nme.Lib.current.stage.stageHeight;
    #end

    // end configure
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function configureStandard():Void
  {
    configure(StageAlign.TOP_LEFT, StageScaleMode.NO_SCALE);
    // end StandardConfiguration
  }

  // end Screen
}
