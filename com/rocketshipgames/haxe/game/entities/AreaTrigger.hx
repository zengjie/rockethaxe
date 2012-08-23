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

import com.rocketshipgames.haxe.gfx.GameSpriteInstance;
import com.rocketshipgames.haxe.gfx.GameSprite;
import com.rocketshipgames.haxe.gfx.GameSpriteContainer;

import com.rocketshipgames.haxe.physics.PhysicsPackage;
import com.rocketshipgames.haxe.physics.CollisionEntity;
import com.rocketshipgames.haxe.physics.CollisionContainer;

class AreaTrigger
  extends GameSpriteInstance,
  implements CollisionEntity
{
  //------------------------------------------------------------
  //------------------------------------------------------------
  public var collidesAs:Int;
  public var collidesWith:Int;

  public var size:Float;

  //------------------------------------------------------------
  private var world:World;
  private var collisionBox:CollisionContainer;
  private var spriteContainer:GameSpriteContainer;

  private var signal:String;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World,
                      spriteContainer:GameSpriteContainer,
                      collisionBox:CollisionContainer,
                      id:String,
                      x:Float, y:Float, cclass:Int,
                      size:Float=-1, visible:Bool=false):Void
  {
    super(spriteContainer, "target");
    world.addEntity(this);
    collisionBox.addEntity(this);

    this.world = world;
    this.collisionBox = collisionBox;
    this.spriteContainer = spriteContainer;

    this.x = x;
    this.y = y;

    this.signal = id;

    if (size==-1)
      size = sprite.width;
    else
      this.size = size;

    this.visible = visible;

    collidesAs = 0;
    collidesWith = cclass;

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function getPhysics():PhysicsPackage { return null; }

  public function left():Float { return x-size/2; }
  public function right():Float { return x+size/2; }
  public function top():Float { return y-size/2; }
  public function bottom():Float { return y+size/2; }

  public function collide(collidedWith:Int, e:CollisionEntity):Void
  {
    //trace("Trigger collide");
    world.signal(signal, e);
    disableSprite();
    collisionBox.removeEntity(this);
    world.removeEntity(this);
    //trace("Done trigger collide");
    // end collide
  }

  public function update(elapsed:Int):Void
  {
    // end update
  }

  public var nextEntity:Entity;
  public var prevEntity:Entity;

  public var nextCollisionEntity:com.rocketshipgames.haxe.physics.CollisionEntity;
  public var prevCollisionEntity:com.rocketshipgames.haxe.physics.CollisionEntity;

  // end AreaTrigger
}
