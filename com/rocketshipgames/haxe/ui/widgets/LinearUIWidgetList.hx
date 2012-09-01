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

package com.rocketshipgames.haxe.ui.widgets;

import nme.display.DisplayObjectContainer;

import com.rocketshipgames.haxe.gfx.Orientation;
import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;

import com.rocketshipgames.haxe.ui.UIWidget;
import com.rocketshipgames.haxe.ui.UIWidgetList;


class LinearUIWidgetList
  extends UIWidgetList
{

  //------------------------------------------------------------
  private var orientation:Orientation;
  private var horizontalAlignment:HorizontalAlignment;
  private var verticalAlignment:VerticalAlignment;

  private var margin:Float;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(x:Float, y:Float,
                      ?container:DisplayObjectContainer,
                      ?opts:Dynamic):Void
  {
    super(x, y, container, opts);

    orientation = HORIZONTAL;
    horizontalAlignment = LEFT;
    verticalAlignment = TOP;

    margin = 0;

    if (opts != null) {
      var d:Dynamic;

      if ((d = Reflect.field(opts, "orientation")) != null) {
        if (Std.is(d, Orientation))
          orientation = d;
        else
          orientation = Type.createEnum(Orientation, d);
      }

      if ((d = Reflect.field(opts, "horizontalAlignment")) != null) {
        if (Std.is(d, HorizontalAlignment))
          horizontalAlignment = d;
        else
          horizontalAlignment = Type.createEnum(HorizontalAlignment, d);
      }

      if ((d = Reflect.field(opts, "verticalAlignment")) != null) {
        if (Std.is(d, VerticalAlignment))
          verticalAlignment = d;
        else
          verticalAlignment = Type.createEnum(VerticalAlignment, d);
      }

      if ((d = Reflect.field(opts, "margin")) != null) {
        if (Std.is(d, Float))
          margin = d;
        else
          margin = Std.parseFloat(d);
      }

      // opts is not null
    }

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  //------------------------------------------------------------
  /*
  public function getX():Float { return x; }
  public function getY():Float { return y; }

  public function setX(x:Float):Float
  {
    for (w in widgets)
      w.setX(w.getX() + (x-listx));
    listx = x;
    return x;
    // end setX
  }

  public function setY(y:Float):Float
  {
    for (w in widgets)
      w.setY(w.getY() + (y-listy));
    listy = y;
    return y;
    // end setY
  }
  */


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function add(widget:UIWidget):Void
  {
    super.add(widget);

    var subWidth:Float;
    var subHeight:Float;

    switch (orientation) {
    case HORIZONTAL:

      subWidth = -margin;
      subHeight = 0;
      for (w in widgets) {
        subWidth += w.width + margin;
        subHeight = Math.max(widget.height, subHeight);
      }

      switch (verticalAlignment) {
      case TOP:
        widget.y = 0;

      case MIDDLE:
        widget.y = -widget.height/2;

      case BOTTOM:
        widget.y = -widget.height;

        // end vertical alignment
      }

      switch (horizontalAlignment) {
      case LEFT:
        var tx:Float = 0;
        for (w in widgets) {
          w.x = tx;
          tx += w.width + margin;
        }

      case CENTER:
        var tx:Float = -subWidth/2;
        for (w in widgets) {
          w.x = tx;
          tx += w.width + margin;
        }

      case RIGHT:
        var tx:Float = 0;
        for (w in widgets) {
          w.x = tx -= w.width;
          tx -= margin;
        }

        // end horizontal alignment
      }


    case VERTICAL:

      subWidth = 0;
      subHeight = -margin;
      for (w in widgets) {
        subWidth = Math.max(widget.width, subWidth);
        subHeight += w.height + margin;
      }

      switch (horizontalAlignment) {
      case LEFT:
        widget.x = 0;

      case CENTER:
        widget.x = -widget.width/2;

      case RIGHT:
        widget.x = -widget.width;
      }

      switch (verticalAlignment) {
      case TOP:
        var ty:Float = 0;
        for (w in widgets) {
          w.y = ty;
          ty += w.height + margin;
        }

      case MIDDLE:
        var ty:Float = -subHeight/2;
        for (w in widgets) {
          w.y = ty;
          ty += w.height + margin;
        }

      case BOTTOM:
        var ty:Float = 0;
        for (w in widgets) {
          w.y = ty -= w.height;
          ty -= margin;
        }

      }

      // end switch orientation
    }

    // end widget
  }

  // end LinearUIWidgetList
}
