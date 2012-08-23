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

package com.rocketshipgames.haxe.text.widgets;

import nme.display.DisplayObjectContainer;

import com.rocketshipgames.haxe.World;

import com.rocketshipgames.haxe.text.GameText;
import com.rocketshipgames.haxe.text.GameTextList;
import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;


enum ArbitraryGameTextChainDirection {
  NORTH;
  SOUTH;
  EAST;
  WEST;
  NONE;
}

class ArbitraryGameTextList
  extends GameTextList
{

  //------------------------------------------------------------
  public var defaultX:Float;
  public var defaultY:Float;

  public var margin:Float;
  public var defaultChain:ArbitraryGameTextChainDirection;

  //------------------------------------------------------------
  private var world:World;

  private var parent:DisplayObjectContainer;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World, parent:DisplayObjectContainer)
  {
    super();
    this.world = world;
    this.parent = parent;
    margin = 0;
    defaultChain = null;
    defaultX = world.screenWidth/2;
    defaultY = world.screenHeight/2;
    // end new
  }

  //------------------------------------------------------------
  public override function receiveText(text:String, opts:Dynamic=null):Void
  {
    var predecessor:GameText = last;
    super.receiveText(text, opts);

    var x:Float;
    var y:Float = defaultY;

    switch (last.horizontalAlignment) {
    case LEFT:
      x = defaultX;
    case CENTER:
      x = defaultX - last.bitmap.width/2;
    case RIGHT:
      x = defaultX - last.bitmap.width;
    }

    switch (last.verticalAlignment) {
    case TOP:
      y = defaultY;
    case MIDDLE:
      y = defaultY - last.bitmap.height/2;
    case BOTTOM:
      y = defaultY - last.bitmap.height;
    }

    var chain:ArbitraryGameTextChainDirection = defaultChain;
    if (opts != null && Reflect.hasField(opts, "chain")) {
      var d:Dynamic = Reflect.field(opts, "chain");
      if (Std.is(d, ArbitraryGameTextChainDirection))
        chain = d;
      else
        chain = Type.createEnum(ArbitraryGameTextChainDirection, d);
    }

    if (chain != null && predecessor != null) {

      switch (chain) {
      case NORTH:
        y = predecessor.bitmap.y - (last.bitmap.height + margin);
        last.verticalAlignment = BOTTOM;

        switch (last.horizontalAlignment) {
        case LEFT:
          x = predecessor.bitmap.x;
        case CENTER:
          x = predecessor.bitmap.x +
            ((predecessor.bitmap.width - last.bitmap.width)/2);
        case RIGHT:
          x = predecessor.bitmap.x +
            (predecessor.bitmap.width - last.bitmap.width);
        };


      case SOUTH:
        y = predecessor.bitmap.y +
          (predecessor.bitmap.height + margin);
        last.verticalAlignment = TOP;

        switch (last.horizontalAlignment) {
        case LEFT:
          x = predecessor.bitmap.x;
        case CENTER:
          x = predecessor.bitmap.x +
            ((predecessor.bitmap.width - last.bitmap.width)/2);
        case RIGHT:
          x = predecessor.bitmap.x +
            (predecessor.bitmap.width - last.bitmap.width);
        };



      case WEST:
        x = predecessor.bitmap.x - (last.bitmap.width + margin);
        last.horizontalAlignment = RIGHT;

        switch (last.verticalAlignment) {
        case TOP:
          y = predecessor.bitmap.y;
        case MIDDLE:
          y = predecessor.bitmap.y +
            ((predecessor.bitmap.height - last.bitmap.height)/2);
        case BOTTOM:
          y = predecessor.bitmap.y +
            (predecessor.bitmap.height - last.bitmap.height);
        };


      case EAST:
        x = predecessor.bitmap.x + (predecessor.bitmap.width + margin);
        last.horizontalAlignment = RIGHT;

        switch (last.verticalAlignment) {
        case TOP:
          y = predecessor.bitmap.y;
        case MIDDLE:
          y = predecessor.bitmap.y +
            ((predecessor.bitmap.height - last.bitmap.height)/2);
        case BOTTOM:
          y = predecessor.bitmap.y +
            (predecessor.bitmap.height - last.bitmap.height);
        };

      case NONE:
      }

      // end chain
    }

    if (opts != null) {
      if (Reflect.hasField(opts, "sx")) {
        var d:Dynamic = Reflect.field(opts, "sx");
        x =  (Std.is(d, String)) ? Std.parseFloat(d): d;
        if (x < 0)
          x += world.screenWidth;

        switch (last.horizontalAlignment) {
        case LEFT:

        case CENTER:
          x = x - last.bitmap.width/2;

        case RIGHT:
          x = x - last.bitmap.width;
        }

        // end explicit coordinate
      }

      if (Reflect.hasField(opts, "sy")) {
        var d:Dynamic = Reflect.field(opts, "sy");
        y =  (Std.is(d, String)) ? Std.parseFloat(d): d;
        if (y < 0)
          y += world.screenHeight;

        switch (last.verticalAlignment) {
        case TOP:

        case MIDDLE:
          y = y - last.bitmap.height/2;

        case BOTTOM:
          y = y - last.bitmap.height;
        }

        // end explicit coordinate
      }
    }

    last.bitmap.x = x;
    last.bitmap.y = y;

    parent.addChild(last.bitmap);
    // end receiveText
  }

  private override function remove(text:GameText)
  {
    parent.removeChild(text.bitmap);
    super.remove(text);
    // end remove
  }

  // end ArbitraryGameTextList
}
