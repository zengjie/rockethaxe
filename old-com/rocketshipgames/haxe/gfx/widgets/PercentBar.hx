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

import com.rocketshipgames.haxe.gfx.Orientation;
import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;
import com.rocketshipgames.haxe.gfx.GrowthDirection;


interface PercentBarGraphic {
  public var x:Float;
  public var y:Float;
  public var visible:Bool;
}


class PercentBar<T:PercentBarGraphic> {

  public var x(default,null):Float;
  public var y(default,null):Float;

  public var width(default, null):Float;
  public var height(default, null):Float;

  //------------------------------------------------------------
  private var currentValue:Float;
  private var maxValue:Float;
  private var currentBar:Int;
  private var numBars:Int;
  private var step:Float;
  private var drawBars:Int;

  private var recalcBars:Bool;
  private var recalcPositions:Bool;

  private var orientation:Orientation;
  private var horizontalAlignment:HorizontalAlignment;
  private var verticalAlignment:VerticalAlignment;

  private var growth:GrowthDirection;

  private var graphics:List<T>;
  private var margin:Float;

  private var visible:Bool;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(x:Float, y:Float,
                      maxValue:Float, numBars:Int,
                      opts:Dynamic):Void
  {
    this.x = x;
    this.y = y;

    this.maxValue = maxValue;
    this.numBars = numBars;
    currentValue = 0;
    currentBar = 0;

    graphics = new List();

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

    calculateNumBars();
    visible = true;
    update(0, true);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function hide():Void
  {
    if (visible) {
      visible = false;
      for (s in graphics)
        s.visible = false;
    }
    // end hide
  }

  public function show():Void
  {
    if (!visible) {
      visible = true;

      update(currentValue, true);

      /*
      var iter:Iterator<T> = graphics.iterator();
      var i:Int = 0;

      while (iter.hasNext() && i < drawBars) {
        iter.next().visible = true;
      }
      */
    }
    // end show
  }

  public function setMaxValue(value:Float):Void
  {
    maxValue = value;
    calculateNumBars();
    update(currentValue, true);
    // end setMaxValue
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function calculateWidth():Void
  {
    if (orientation == VERTICAL)
      width = graphicWidth();
    else if (drawBars == 0)
      width = 0;
    else
      width = (drawBars * (graphicWidth() + margin)) - margin;
    // end calculateWidth
  }

  //------------------------------------------------------------
  public function calculateHeight():Void
  {
    if (orientation == HORIZONTAL)
      height = graphicHeight();
    if (drawBars == 0)
      height = 0;
    else
      height = (drawBars * (graphicHeight() + margin)) - margin;
    // end calculateHeight
  }

  //------------------------------------------------------------
  private function calculateNumBars():Void
  {

    recalcBars = false;
    recalcPositions = false;
    step = 1;

    if (maxValue <= 0 && numBars <= 0) {
      drawBars = Math.ceil(currentValue);
      recalcBars = true;

      if ((orientation == VERTICAL && verticalAlignment == MIDDLE) ||
          (orientation == HORIZONTAL && horizontalAlignment == CENTER)) {
        recalcPositions = true;
      }

    } else if (maxValue > 0 && numBars > 0) {
      step = maxValue/numBars;
      drawBars = numBars;

    } else if (numBars > 0) {
      drawBars = numBars;

    } else {
      drawBars = Math.ceil(maxValue);
    }

    calculateWidth();
    calculateHeight();

    //trace("Updated to max " + maxValue + " num " + numBars +
    //      " step " + step + " drawBars " + drawBars);

    // end calculateNumBars
  }

  private function recalculateBars():Void
  {
    drawBars = Math.ceil(currentValue);
    calculateWidth();
    calculateHeight();
    // end recalculateBars
  }

  private function recalculatePositions():Void
  {
    var position:Int = 0;
    for (g in graphics) {
      calculatePosition(g, position);
      position++;
    }
    // end recalculatePositions
  }

  //------------------------------------------------------------
  private function calculatePosition(g:T, position:Int):Void
  {
    var pos:Int;

    switch (growth) {
    case FORWARD:
      pos = position;
    case REVERSE:
      pos = drawBars - (position+1);
    }

    switch (orientation) {
    case HORIZONTAL:
      switch (verticalAlignment) {
      case TOP:
        g.y = y + graphicHeight()/2;
      case BOTTOM:
        g.y = y - graphicHeight()/2;
      case MIDDLE:
        g.y = y;
      }

      switch (horizontalAlignment) {
      case LEFT:
        g.x = x + (pos * (margin + graphicWidth())) + graphicWidth()/2;
      case RIGHT:
        g.x = x - ((pos * (margin + graphicWidth())) + graphicWidth()/2);
      case CENTER:
        g.x = (x - width/2) +
          ((pos * (margin + graphicWidth())) + graphicWidth()/2);
      }


    case VERTICAL:
      switch (horizontalAlignment) {
      case LEFT:
        g.x = x + graphicWidth()/2;
      case RIGHT:
        g.x = x - graphicWidth()/2;
      case CENTER:
        g.x = x;
      }

      switch (verticalAlignment) {
      case TOP:
        g.y = y + (pos * (margin + graphicHeight())) + graphicHeight()/2;
      case BOTTOM:
        g.y = y - ((pos * (margin + graphicHeight())) + graphicHeight()/2);
      case MIDDLE:
        g.y = (y - height/2) +
          ((pos * (margin + graphicHeight())) + graphicHeight()/2);
      }

      // end switch orientation
    }

    // trace("Position " + pos + " x,y " + g.x + "," + g.y);

    // end calculatePosition
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function increment(i:Float = 1):Void
  {
    update(currentValue+i);
    // end increment
  }

  public function update(value:Float, dirty:Bool = false):Void
  {
    if (maxValue > 0 && value > maxValue)
      value = maxValue;

    var bar:Int = Math.ceil(value/step);
    currentValue = value;

    if (bar == currentBar && !dirty)
      return;

    currentBar = bar;

    // trace("Current bar " + currentBar + " value " + currentValue);

    if (recalcBars)
      recalculateBars();

    if (recalcPositions)
      recalculatePositions();

    for (position in graphics.length...drawBars) {
      var g:T = newGraphic(position);
      calculatePosition(g, position);
      g.visible = visible;
      graphics.add(g);
    }

    var g:T;
    var iter = graphics.iterator();
    var position:Int = 0;
    while (position < currentBar) {
      g = iter.next();
      setEnabledGraphic(g, position);
      position++;
    }

    while (position < drawBars) {
      g = iter.next();
      setDisabledGraphic(g, position);
      position++;
    }

    while (iter.hasNext()) {
      iter.next().visible = false;
    }

    // end update
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function graphicWidth():Float { return 0; }
  private function graphicHeight():Float { return 0; }

  private function newGraphic(position:Int):T { return null; }
  private function setEnabledGraphic(g:T, position:Int):Void {}
  private function setDisabledGraphic(g:T, position:Int):Void {}

  // end PercentBar
}
