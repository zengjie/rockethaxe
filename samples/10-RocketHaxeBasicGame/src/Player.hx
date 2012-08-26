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

import nme.Assets;

import com.rocketshipgames.haxe.World;
import com.rocketshipgames.haxe.gfx.GameSpriteContainer;
import com.rocketshipgames.haxe.physics.CollisionContainer;

import com.rocketshipgames.haxe.physics.CollisionEntity;

import com.rocketshipgames.haxe.game.entities.BasicGameSpriteEntity;
import com.rocketshipgames.haxe.physics.packages.ShooterPhysicsPackage;

import com.rocketshipgames.haxe.ui.Keyboard;

import com.rocketshipgames.haxe.sfx.SoundEffect;


class Player
  extends BasicGameSpriteEntity
{

  //------------------------------------------------------------
  private static inline var ACCELERATION:Float = 2000;
  private static inline var MIN_VELOCITY:Float = 2;
  private static inline var MAX_VELOCITY:Float = 300;

  private static inline var SHOT_INTERVAL:Int = 200;

  private var game:RocketHaxeBasicGame;

  private var enginesOnFrame:Int;
  private var enginesOffFrame:Int;

  private var shotClock:Int;
  private var shields:Int;

  private var sfxExplosion:SoundEffect;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(game:RocketHaxeBasicGame,
                      collisionContainer:CollisionContainer,
                      gfxContainer:GameSpriteContainer,
                      opts:Array<Dynamic>=null):Void
  {
    super(game, collisionContainer, gfxContainer, "player", opts);

    var physics:ShooterPhysicsPackage = new ShooterPhysicsPackage(this);
    physics.xdrag = physics.ydrag = ACCELERATION/2;
    physics.xvelMin = physics.yvelMin = MIN_VELOCITY;
    physics.xvelMax = physics.yvelMax = MAX_VELOCITY;
    physics.setBounds(BOUNDS_STOP, world);
    this.physics = physics;

    collidesAs = RocketHaxeBasicGame.COLLIDES_PLAYER;
    collidesWith = RocketHaxeBasicGame.COLLIDES_ASTEROID;

    sfxExplosion = new SoundEffect(Assets.getSound("assets/explosion.wav"));

    enginesOnFrame = sprite.keyframe("engines");
    enginesOffFrame = sprite.keyframe("idle");

    hitXBuffer = 4; // Give the player a safety margin.
    hitYBuffer = 4;

    this.game = game;

    init(opts);

    // end new
  }

  //------------------------------------------------------------
  public override function init(_opts:Array<Dynamic> = null):Void
  {
    super.init(_opts);

    physics.xvel = physics.yvel = 0;
    x = world.worldWidth/2;
    y = 3*world.worldHeight/4;

    shotClock = 0;
    shields = 5;
    // end init
  }

  public override function destroyed():Void
  {
    sfxExplosion.play();
    super.destroyed();
      // end destroyed
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function update(elapsed:Int):Void
  {

    physics.xacc = 0;
    physics.yacc = 0;

    if (Keyboard.isKeyDown(Keyboard.LEFT))
      physics.xacc = -ACCELERATION;

    if (Keyboard.isKeyDown(Keyboard.RIGHT))
      physics.xacc = ACCELERATION;

    if (Keyboard.isKeyDown(Keyboard.UP))
      physics.yacc = -ACCELERATION;

    if (Keyboard.isKeyDown(Keyboard.DOWN))
      physics.yacc = ACCELERATION;

    shotClock -= elapsed;
    if (shotClock <= 0 && Keyboard.isKeyDown(Keyboard.SPACE)) {
      shotClock = SHOT_INTERVAL;
      game.newBullet(x, y-sprite.height/2,
                     physics.xvel, physics.yvel);
    }

    super.update(elapsed);

    if (physics.yvel < -physics.yvelMin)
      frame = enginesOnFrame;
    else
      frame = enginesOffFrame;

    // end update
  }

  //------------------------------------------------------------
  public override function collide(collidedWith:Int, e:CollisionEntity):Void
  {
    shields--;
    if (shields <= 0) {
      // Generally damage effects and removing an object should
      // probably go in the main loop, but it won't cause a problem in
      // the internals to remove in the middle of collision response.
      destroyed();
    } else {
      trace("Shields down to " + shields + "!");
    }
    // end collide
  }

  // end Player
}
