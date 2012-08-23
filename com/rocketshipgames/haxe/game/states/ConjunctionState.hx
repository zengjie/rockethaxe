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

package com.rocketshipgames.haxe.game.states;

import com.rocketshipgames.haxe.World;
import com.rocketshipgames.haxe.State;

class ConjunctionState
  implements State
{

  //------------------------------------------------------------
  private var world:World;
  private var id:String;
  private var states:List<String>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World, id:String, ids:Array<String>):Void
  {
    this.world = world;
    this.id = id;
    this.states = new List(); // Convert to list for faster iteration (?)

    // Note that we can't bind to these beforehand as they may not
    // exist when ConjunctionState is created or may change, so these
    // are kept as Strings rather than fetching States.
    for (i in ids)
      states.add(i);

    world.addState(id, this);

    // end new
  }

  //------------------------------------------------------------
  public function remove(id:String):Void
  {
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function getValue(id:String):Dynamic
  {

    var res:Bool = true;
    var d:Dynamic;
    for (i in states) {
      d = world.getStateValue(i);
      if (d == null) {
        res = false;
        break;
      }
    }

    return res;
    // end getValue
  }

  // end ConjunctionState
}
