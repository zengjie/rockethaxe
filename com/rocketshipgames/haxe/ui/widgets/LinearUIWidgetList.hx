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

class LinearUIWidgetList {

  public var x:Float;
  public var y:Float;

  public var width:Float;
  public var height:Float;

  //------------------------------------------------------------
  private var orientation:Orientation;
  private var horizontalAlignment:HorizontalAlignment;
  private var verticalAlignment:VerticalAlignment;

  private var growth:GrowthDirection;

  private var margin:Float;

  private var widgets:List<UIWidget>;

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
  public function add(widget:UIWidget):Void
  {
    var prev:UIWidget = widgets.last();

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
        width += w.width + margin;
      height = Math.max(widget.height, height);

      switch (verticalAlignment) {
      case TOP:
        widget.y = y;

      case MIDDLE:
        widget.y = y - widget.height /2;

      case BOTTOM:
        widget.y = y - widget.height;
        // end vertical alignment
      }

      switch (horizontalAlignment) {
      case LEFT:
        var tx:Float = x;
        for (w in widgets) {
          w.x = tx;
          tx += w.width + margin;
        }

      case CENTER:
        var tx:Float = x-width/2;
        for (w in widgets) {
          w.x = tx;
          tx += w.width + margin;
        }

      case RIGHT:
        var tx:Float = x;
        for (w in widgets) {
          w.x = tx -= w.width;
          tx -= margin;
        }

        // end horizontal alignment
      }


    case VERTICAL:

      width = Math.max(widget.width, width);
      height = -margin;
      for (w in widgets)
        height += w.height + margin;

      switch (horizontalAlignment) {
      case LEFT:
        widget.x = x;

      case CENTER:
        widget.x = x - widget.width / 2;

      case RIGHT:
        widget.x = x - widget.width;
      }

      switch (verticalAlignment) {
      case TOP:
        var ty:Float = y;
        for (w in widgets) {
          w.y = ty;
          ty += w.height + margin;
        }

      case MIDDLE:
        var ty:Float = y-height/2;
        for (w in widgets) {
          w.y = ty;
          ty += w.height + margin;
        }

      case BOTTOM:
        var ty:Float = y;
        for (w in widgets) {
          w.y = ty -= w.height;
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
