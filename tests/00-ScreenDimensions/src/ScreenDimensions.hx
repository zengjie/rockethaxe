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

// import nme.display.Shape;

import nme.display.StageAlign;
import nme.display.StageScaleMode;

class ScreenDimensions
{

  public static function main():Void
  {
    //trace("Stage w,h is " + nme.Lib.current.stage.stageWidth + "x" +
    //      nme.Lib.current.stage.stageHeight);
    trace("Stage w,h is " + nme.Lib.current.stage.stageWidth + "x" +
          nme.Lib.current.stage.stageHeight);

    nme.Lib.current.stage.align = StageAlign.TOP_LEFT;
    nme.Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

    trace("Stage w,h is " + nme.Lib.current.stage.stageWidth + "x" +
          nme.Lib.current.stage.stageHeight);


    /*
    var circle:Shape = new Shape();
    circle.graphics.beginFill(0xFFFF0000);
    circle.graphics.drawCircle(0, 0, 10);
    circle.graphics.endFill();
    nme.Lib.current.stage.addChild(circle);

    circle = new Shape();
    circle.graphics.beginFill(0xFFFF0000);
    circle.graphics.drawCircle
      (nme.Lib.current.stage.stageWidth, nme.Lib.current.stage.stageHeight, 10);
    circle.graphics.endFill();
    nme.Lib.current.stage.addChild(circle);
    */

    // end main
  }

  // end ScreenDimensions
}
