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

import com.rocketshipgames.haxe.gfx.Orientation;
import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;
import com.rocketshipgames.haxe.gfx.GrowthDirection;

import com.rocketshipgames.haxe.ui.UIWidget;

class LinearUIWidgetList
  implements UIWidget
{

  //------------------------------------------------------------
  private var orientation:Orientation;
  private var horizontalAlignment:HorizontalAlignment;
  private var verticalAlignment:VerticalAlignment;

  private var growth:GrowthDirection;

  private var margin:Float;

  private var widgets:List<UIWidget>;

  private var x:Float;
  private var y:Float;

  private var width:Float;
  private var height:Float;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(x:Float, y:Float,
                      ?opts:Dynamic):Void
  {
    this.x = x;
    this.y = y;

    width = 0;
    height = 0;

    orientation = HORIZONTAL;
    horizontalAlignment = LEFT;
    verticalAlignment = TOP;
    growth = FORWARD;

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

      if ((d = Reflect.field(opts, "direction")) != null) {
        if (Std.is(d, GrowthDirection))
          growth = d;
        else
          growth = Type.createEnum(GrowthDirection, d);
      }

      if ((d = Reflect.field(opts, "margin")) != null) {
        if (Std.is(d, Float))
          margin = d;
        else
          margin = Std.parseFloat(d);
      }

      // opts is not null
    }


    widgets = new List();

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  //------------------------------------------------------------
  public function getX():Float { return x; }
  public function getY():Float { return y; }

  public function setX(x:Float):Float
  {
    for (w in widgets)
      w.setX(w.getX() + (x-this.x));
    this.x = x;
    return x;
    // end setX
  }

  public function setY(y:Float):Float
  {
    for (w in widgets)
      w.setY(w.getY() + (y-this.y));
    this.y = y;
    return y;
    // end setY
  }

  public function getWidth():Float { return width; }
  public function getHeight():Float { return height; }

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


    switch (orientation) {
    case HORIZONTAL:

      width = -margin;
      for (w in widgets)
        width += w.getWidth() + margin;
      height = Math.max(widget.getHeight(), height);

      switch (verticalAlignment) {
      case TOP:
        widget.setY(y);

      case MIDDLE:
        widget.setY(y - widget.getHeight()/2);

      case BOTTOM:
        widget.setY(y - widget.getHeight());
        // end vertical alignment
      }

      switch (horizontalAlignment) {
      case LEFT:
        var tx:Float = x;
        for (w in widgets) {
          w.setX(tx);
          tx += w.getWidth() + margin;
        }

      case CENTER:
        var tx:Float = x-width/2;
        for (w in widgets) {
          w.setX(tx);
          tx += w.getWidth() + margin;
        }

      case RIGHT:
        var tx:Float = x;
        for (w in widgets) {
          w.setX(tx -= w.getWidth());
          tx -= margin;
        }

        // end horizontal alignment
      }


    case VERTICAL:

      width = Math.max(widget.getWidth(), width);
      height = -margin;
      for (w in widgets)
        height += w.getHeight() + margin;

      switch (horizontalAlignment) {
      case LEFT:
        widget.setX(x);

      case CENTER:
        widget.setX(x - widget.getWidth()/2);

      case RIGHT:
        widget.setX(x - widget.getWidth());
      }

      switch (verticalAlignment) {
      case TOP:
        var ty:Float = y;
        for (w in widgets) {
          w.setY(ty);
          ty += w.getHeight() + margin;
        }

      case MIDDLE:
        var ty:Float = y-height/2;
        for (w in widgets) {
          w.setY(ty);
          ty += w.getHeight() + margin;
        }

      case BOTTOM:
        var ty:Float = y;
        for (w in widgets) {
          w.setY(ty -= w.getHeight());
          ty -= margin;
        }

      }

      // end switch orientation
    }

    // end widget
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    for (w in widgets)
      w.show(opts);
    // end show
  }

  public function hide(?opts:Dynamic):Void
  {
    for (w in widgets)
      w.hide(opts);
    // end hide
  }

  // end LinearUIWidgetList
}
