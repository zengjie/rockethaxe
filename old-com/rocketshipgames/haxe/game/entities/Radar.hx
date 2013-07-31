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

import com.rocketshipgames.haxe.physics.PhysicalEntity;
import com.rocketshipgames.haxe.physics.PhysicsPackage;
import com.rocketshipgames.haxe.physics.CollisionContainer;
import com.rocketshipgames.haxe.physics.CollisionEntity;

class Radar
  implements CollisionEntity
{

  //------------------------------------------------------------
  public var x:Float;
  public var y:Float;

  public var xoff:Float;
  public var yoff:Float;

  public var width:Float;
  public var height:Float;

  public var collidesAs:Int;
  public var collidesWith:Int;

  public var detects:Int;

  public var signal:CollisionEntity->Void;

  public var detectParent:Bool = false;

  //------------------------------------------------------------
  private var world:World;
  private var collisionContainer:CollisionContainer;
  private var parent:PhysicalEntity;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World,
                      collisionContainer:CollisionContainer,
                      parent:PhysicalEntity,
                      width:Float, height:Float,
                      detects:Int,
                      signal:CollisionEntity->Void):Void
  {
    this.world = world;
    this.collisionContainer = collisionContainer;

    this.parent = parent;
    this.width = width;
    this.height = height;
    this.detects = detects;
    this.signal = signal;

    xoff = 0;
    yoff = 0;

    // end new
  }

  /*
  public function remove():Void
  {
    world.removeEntity(this);
    collisionContainer.removeEntity(this);
    // end remove
  }
  */

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function enable():Void
  {
    x = parent.x + xoff;
    y = parent.y + yoff;

    collidesWith = detects;
    collidesAs = 0;

    world.addEntity(this);
    collisionContainer.addEntity(this);
    // end enable
  }

  public function disable():Void
  {
    collidesWith = 0;
    collidesAs = 0;

    collisionContainer.removeEntity(this);
    world.removeEntity(this);
    // end disable
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function collide(collidedWith:Int, e:CollisionEntity):Void
  {
    if (e == parent && !detectParent)
      return;
    signal(e);
    // end collide
  }

  public function left():Float { return x-width/2; }
  public function right():Float { return x+width/2; }
  public function top():Float { return y-height/2; }
  public function bottom():Float { return y+height/2; }

  public function getPhysics():PhysicsPackage { return null; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    x = parent.x + xoff;
    y = parent.y + yoff;
    // end update
  }

  public var nextEntity:Entity;
  public var prevEntity:Entity;

  public var nextCollisionEntity:com.rocketshipgames.haxe.physics.CollisionEntity;
  public var prevCollisionEntity:com.rocketshipgames.haxe.physics.CollisionEntity;

  // end Radar
}
