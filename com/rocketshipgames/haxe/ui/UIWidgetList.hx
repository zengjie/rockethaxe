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

package com.rocketshipgames.haxe.ui;

import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

import com.rocketshipgames.haxe.gfx.GrowthDirection;

import com.rocketshipgames.haxe.ui.UIWidget;


class UIWidgetList
  extends Sprite,
  implements UIWidget
{

  //------------------------------------------------------------
  private var widgets:List<UIWidget>;

  private var growth:GrowthDirection;

  private var baseX:Float;
  private var baseY:Float;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(x:Float, y:Float,
                      ?container:DisplayObjectContainer,
                      ?opts:Dynamic):Void
  {
    super();

    this.x = baseX = x;
    this.y = baseY = y;

    growth = FORWARD;

    widgets = new List();

    if (opts != null) {
      var d:Dynamic;

      if ((d = Reflect.field(opts, "direction")) != null) {
        if (Std.is(d, GrowthDirection))
          growth = d;
        else
          growth = Type.createEnum(GrowthDirection, d);
      }
    }

    visible = false;
    if (container != null)
      container.addChild(this);

    // end new
  }

  public function setContainer(container:DisplayObjectContainer):Void
  {
    if (parent != null)
      parent.removeChild(this);
    container.addChild(this);
    // end setContainer
  }

  public function remove():Void
  {
    if (parent != null)
      parent.removeChild(this);
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  //------------------------------------------------------------
  public function getX():Float { return x; }
  public function getY():Float { return y; }

  public function setX(x:Float):Float { return this.x = x; }
  public function setY(y:Float):Float { return this.y = y; }

  public function getWidth():Float { return width; }
  public function getHeight():Float { return height; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    visible = true;
    // end show
  }

  public function hide(?opts:Dynamic):Void
  {
    visible = false;
    // end hide
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function add(widget:UIWidget):Void
  {

    switch (growth) {
    case FORWARD:
      widgets.add(widget);

    case REVERSE:
      widgets.push(widget);
    }

    widget.setContainer(this);

    widget.show();

    // end add
  }

  // end LinearUIWidgetList
}
