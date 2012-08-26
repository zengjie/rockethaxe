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


import com.rocketshipgames.haxe.World;
import com.rocketshipgames.haxe.gfx.GameSpriteContainer;
import com.rocketshipgames.haxe.physics.CollisionContainer;

import com.rocketshipgames.haxe.gfx.GameSprite.GameSpriteAnimation;

import com.rocketshipgames.haxe.physics.CollisionEntity;

import com.rocketshipgames.haxe.game.entities.BasicGameSpriteEntity;

import com.rocketshipgames.haxe.physics.packages.ShooterPhysicsPackage;


class Asteroid
  extends BasicGameSpriteEntity
{

  //------------------------------------------------------------
  private static inline var ACCELERATION:Float = 100;
  private static inline var MIN_VELOCITY:Float = 2;
  private static inline var MAX_VELOCITY:Float = 50;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(game:RocketHaxeBasicGame,
                      collisionContainer:CollisionContainer,
                      gfxContainer:GameSpriteContainer,
                      opts:Array<Dynamic>):Void
  {
    super(game, collisionContainer, gfxContainer, "asteroid");

    var physics:ShooterPhysicsPackage = new ShooterPhysicsPackage(this);
    physics.xdrag = physics.ydrag = ACCELERATION/2;
    physics.xvelMin = physics.yvelMin = MIN_VELOCITY;
    physics.xvelMax = physics.yvelMax = MAX_VELOCITY;

    physics.offBoundsLeft = physics.cycleLeft;
    physics.offBoundsRight = physics.cycleRight;
    physics.offBoundsTop = physics.cannotLeaveTop;
    physics.offBoundsBottom = leftWorld;
    physics.setBounds(BOUNDS_DETECT, world);

    this.physics = physics;

    collidesAs = RocketHaxeBasicGame.COLLIDES_ASTEROID;
    collidesWith = RocketHaxeBasicGame.COLLIDES_PLAYER |
      RocketHaxeBasicGame.COLLIDES_BULLET;

    hitXBuffer = 6; // The sprite's a bit oversized due to the
    hitYBuffer = 6; // rotation, so cut it down a bit.

    init(opts);

    // end new
  }

  //------------------------------------------------------------
  public override function init(_opts:Array<Dynamic> = null):Void
  {
    super.init(_opts);

    x = Math.random()*world.worldWidth;
    y = -sprite.height/2;
    physics.xvel = physics.yvel = 0;
    physics.xacc = (Math.random() * 2 * ACCELERATION) - ACCELERATION;
    physics.yacc = ACCELERATION;

    play(sprite.animation("tumble"));
    // end init
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function collide(collidedWith:Int, e:CollisionEntity):Void
  {
    destroyed();
    // end collide
  }

  // end Asteroid
}
