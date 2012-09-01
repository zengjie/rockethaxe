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

package com.rocketshipgames.haxe.game;

import com.rocketshipgames.haxe.World;

class GameEventUtils
{

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  //-- Convenience functions
  public static function getX(world:World,
                              params:Hash<String>, opts:Dynamic = null,
                              field:String = "x"):Float
  {
    if (!params.exists(field))
      return 0;

    var x:Float;

    var val:String = params.get(field);
    var i:Int;
    if ((i=val.indexOf("/")) != -1) {
      x = world.worldWidth * Std.parseFloat(val.substr(0,i)) /
        Std.parseFloat(val.substr(i+1));
    } else {
      x = Std.parseFloat(val);
    }

    if (opts != null)
      Reflect.setField(opts, field, x);

    return x;

    // end getX
  }

  public static function getY(world:World,
                              params:Hash<String>, opts:Dynamic = null,
                              field:String = "y"):Float
  {
    if (!params.exists(field))
      return 0;

    var y:Float;

    var val:String = params.get(field);
    var i:Int;
    if ((i=val.indexOf("/")) != -1) {
      y = world.worldHeight * Std.parseFloat(val.substr(0,i)) /
        Std.parseFloat(val.substr(i+1));
    } else {
      y = Std.parseFloat(val);
    }

    if (opts != null)
      Reflect.setField(opts, field, y);

    return y;

    // end getY
  }


  public static function getScreenX(world:World,
                                    params:Hash<String>, opts:Dynamic = null,
                                    field:String = "sx"):Float
  {
    if (!params.exists(field))
      return 0;

    var x:Float;

    var val:String = params.get(field);
    var i:Int;
    if ((i=val.indexOf("/")) != -1) {
      x = world.displayWidth * Std.parseFloat(val.substr(0,i)) /
        Std.parseFloat(val.substr(i+1));
    } else {
      x = Std.parseFloat(val);
    }

    if (opts != null)
      Reflect.setField(opts, field, x);

    return x;

    // end getScreenX
  }


  public static function getScreenY(world:World,
                                    params:Hash<String>, opts:Dynamic = null,
                                    field:String = "sy"):Float
  {
    if (!params.exists(field))
      return 0;

    var y:Float;

    var val:String = params.get(field);
    var i:Int;
    if ((i=val.indexOf("/")) != -1) {
      y = world.displayHeight * Std.parseFloat(val.substr(0,i)) /
        Std.parseFloat(val.substr(i+1));
    } else {
      y = Std.parseFloat(val);
    }

    if (opts != null)
      Reflect.setField(opts, field, y);

    return y;

    // end getScreenY
  }

  // end GameEventUtils
}
