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

package com.rocketshipgames.haxe.game.events;

import com.rocketshipgames.haxe.World;

import com.rocketshipgames.haxe.gfx.GameSpriteContainer;

import com.rocketshipgames.haxe.physics.CollisionContainer;

import com.rocketshipgames.haxe.game.GameEvent;
import com.rocketshipgames.haxe.game.GameEventsFactory;
import com.rocketshipgames.haxe.game.GameEventUtils;

import com.rocketshipgames.haxe.game.entities.AreaTrigger;

class SpawnAreaTriggerEvent
  implements GameEvent
{

  public var world:World;
  public var container:GameSpriteContainer;
  public var collisionBox:CollisionContainer;

  private var x:Float;
  private var y:Float;
  private var visible:Bool = false;
  private var size:Float = -1;
  private var cclass:Int = 0;
  private var id:String;

  public function new(eventsFactory:GameEventsFactory,
                      params:Hash<String>):Void
  {
    this.world = eventsFactory.demultiplexWorld(params.get("world"));
    this.container = eventsFactory.demultiplexGameSpriteContainer
      (params.get("sprites"));
    this.collisionBox = eventsFactory.demultiplexCollisionContainer
      (params.get("collisions"));

    x = GameEventUtils.getX(world, params);
    y = GameEventUtils.getY(world, params);

    if (params.exists("id"))
      id = params.get("id");
    else
      id = "area";

    if (params.exists("size"))
      size = Std.parseFloat(params.get("size"));

    if (params.exists("visible") && params.get("visible") == "true")
      visible = true;

    if (params.exists("detect")) {
      var str:String = params.get("detect");
      var map:Hash<Int> = eventsFactory.getCollisionClassMap();

      var i:Int;
      var p:Int = 0;
      do {
        i = str.indexOf("|", p);
        if (i == -1)
          i = str.length;

        var cl:String = str.substr(p, i-p);

        if (map.exists(cl)) {
          cclass |= map.get(cl);
        }

        p = i+1;
      } while (p < str.length);
      // end detect
    }

    // end new
  }

  public function fire():Void
  {
    new AreaTrigger(world, container, collisionBox,
                    id, x, y, cclass, size, visible);
    // end fire
  }

  // end SpawnAreaTriggerEvent
}
