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

import com.rocketshipgames.haxe.Entity;
import com.rocketshipgames.haxe.World;

import com.rocketshipgames.haxe.gfx.GameSprite;
import com.rocketshipgames.haxe.gfx.GameSpriteInstance;
import com.rocketshipgames.haxe.gfx.GameSpriteContainer;

import com.rocketshipgames.haxe.physics.PhysicsPackage;
import com.rocketshipgames.haxe.physics.CollisionEntity;
import com.rocketshipgames.haxe.physics.CollisionContainer;

import com.rocketshipgames.haxe.ds.Deadpool;
import com.rocketshipgames.haxe.ds.DeadpoolObject;

class BasicGameSpriteEntity
  extends GameSpriteInstance,
  implements CollisionEntity,
  implements DeadpoolObject
{

  //------------------------------------------------------------
  public var collidesAs:Int;
  public var collidesWith:Int;

  public var dead:Bool;

  //------------------------------------------------------------
  private var world:World;
  private var collisionContainer:CollisionContainer;

  private var physics:PhysicsPackage;

  private var deadpool:Deadpool<DeadpoolObject>;

  private var killSignal:String;
  private var exitSignal:String;

  private var hitXBuffer:Float;
  private var hitYBuffer:Float;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World,
                      collisionContainer:CollisionContainer,
                      gfxContainer:GameSpriteContainer,
                      spriteName:String = null,
                      layer:Int = 0,
                      opts:Array<Dynamic> = null):Void
  {
    super(gfxContainer, layer, spriteName, false);

    this.world = world;
    this.collisionContainer = collisionContainer;

    hitXBuffer = 0;
    hitYBuffer = 0;

    if (physics == null)
      physics = new PhysicsPackage(this);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function init(_opts:Array<Dynamic> = null):Void
  {
    var d:Dynamic;
    var opts:Dynamic;
    if (_opts != null && _opts.length > 0)
      opts = _opts[0];
    else
      opts = null;

    //-- Restore basic live properties
    dead = false;
    // visible = true;

    //-- Set up signals
    if (opts != null && (d = Reflect.field(opts, "killSignal")) != null) {
      killSignal = d;
    } else
      killSignal = null;

    if (opts != null && (d = Reflect.field(opts, "exitSignal")) != null) {
      exitSignal = d;
    } else
      exitSignal = null;

    //-- Put us back into the world
    world.addEntity(this);
    collisionContainer.addEntity(this);
    enableSprite();

    // end init
  }

  //------------------------------------------------------------
  public function setDeadpool(deadpool:Deadpool<DeadpoolObject>):Void
  {
    this.deadpool = deadpool;
    // end setDeadpool
  }

  //------------------------------------------------------------
  public function destroyed():Void
  {
    if (killSignal != null)
      world.signal(killSignal, this);

    makeDead();
    // end destroyed
  }

  public function leftWorld():Void
  {
    if (exitSignal != null)
      world.signal(exitSignal, this);

    makeDead();
    // end leftWorld
  }

  public function makeDead():Void
  {
    //-- Take us from the world
    disableSprite();
    collisionContainer.removeEntity(this);
    world.removeEntity(this);

    dead = true;

    /*
    visible = false;
    collidesAs = 0;
    collidesWith = 0;
    */

    if (deadpool != null)
      deadpool.returnObject(this);

    // end makeDead
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function left():Float
  {
    return x-(sprite.width/2-hitXBuffer);
  }
  public function right():Float
  {
    return x+(sprite.width/2-hitXBuffer);
  }
  public function top():Float
  {
    return y-(sprite.height/2-hitYBuffer);
  }
  public function bottom():Float
  {
    return y+(sprite.height/2-hitYBuffer);
  }

  public function collide(collidedWith:Int, e:CollisionEntity):Void { }

  public function getPhysics():PhysicsPackage { return physics; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    if (dead)
      return;

    physics.update(elapsed);

    // end update
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public var nextEntity:Entity;
  public var prevEntity:Entity;

  public var nextCollisionEntity:CollisionEntity;
  public var prevCollisionEntity:CollisionEntity;

  // end BasicGameSpriteEntity
}
