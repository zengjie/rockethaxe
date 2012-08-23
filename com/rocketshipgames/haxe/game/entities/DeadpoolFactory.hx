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

package com.rocketshipgames.haxe.game.entities;

import com.rocketshipgames.haxe.World;

import com.rocketshipgames.haxe.Entity;

import com.rocketshipgames.haxe.ds.Deadpool;
import com.rocketshipgames.haxe.ds.DeadpoolObject;

class DeadpoolFactory<T:DeadpoolObject>
  implements Entity
{

  public var startClock:Int = 0;
  public var minInterval:Int = 1000;
  public var maxInterval:Int = 3000;

  public var opts:Array<Dynamic>;

  //------------------------------------------------------------
  private var world:World;
  private var deadpool:Deadpool<T>;

  private var clock:Int;
  private var active:Bool = true;

  private var id:String = null;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World,
                      deadpool:Deadpool<T>,
                      id:String,
                      opts:Array<Dynamic> = null):Void
  {
    this.world = world;
    this.deadpool = deadpool;
    this.opts = opts;

    if (id != null) {
      this.id = id;
      world.addSignal(this.id, signal);
    }

    world.addEntity(this);
    // end DeadpoolFactory
  }

  public function remove():Void
  {
    world.removeEntity(this);
    world.removeSignal(id, signal);
    // end remove
  }

  //------------------------------------------------------------
  public function restart(time:Int = -1):Void
  {
    if (time >= 0)
      startClock = time;

    active = true;
    clock = startClock;
    // end start
  }

  public function pause():Void
  {
    active = false;
  }

  public function resume():Void
  {
    active = true;
    // end disable
  }

  public function toggle(reset:Bool = false):Void
  {
    if (!active) {
      active = true;
      if (reset)
        clock = startClock;
    } else {
      active = false;
    }
    // end toggle
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function signal(id:String, message:Dynamic):Bool
  {
    remove();
    return false;
    // end signal
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    if (!active)
      return;

    clock -= elapsed;
    if (clock <= 0) {
      deadpool.newObject(opts);
      clock = minInterval +
        Std.int(Math.random() * (maxInterval - minInterval));
    }

    // end update
  }

  public var nextEntity:Entity;
  public var prevEntity:Entity;

  // end DeadpoolFactory
}
