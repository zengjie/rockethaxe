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

import nme.display.StageAlign;
import nme.display.StageScaleMode;

import com.rocketshipgames.haxe.debug.DebugConsole;
import com.rocketshipgames.haxe.debug.FPSDisplay;

import com.rocketshipgames.haxe.World;

import com.rocketshipgames.haxe.gfx.GameSpriteContainer;

import com.rocketshipgames.haxe.physics.CollisionContainer;

import com.rocketshipgames.haxe.ds.Deadpool;

import com.rocketshipgames.haxe.ui.Keyboard;

import com.rocketshipgames.haxe.util.TimeUtils;


class RocketHaxeBasicGame
  extends com.rocketshipgames.haxe.GameLoop
{

  public static inline var COLLIDES_PLAYER:Int = 1;
  public static inline var COLLIDES_BULLET:Int = 2;
  public static inline var COLLIDES_ASTEROID:Int = 4;

  //------------------------------------------------------------
  private var spriteContainer:GameSpriteContainer;
  private var collisionContainer:CollisionContainer;

  private var bulletPool:Deadpool<Bullet>;
  private var asteroidPool:Deadpool<Asteroid>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(width:Float, height:Float):Void
  {
    super(width, height);

    addGraphicsContainer(spriteContainer =
                         new GameSpriteContainer
                         (Assets.getBitmapData("assets/sprites.png"),
                          Assets.getText("assets/sprites.xml")));

    collisionContainer =
      new com.rocketshipgames.haxe.physics.collisions.SweepScanCollisionContainer();

    bulletPool = new Deadpool
      (function(opts:Array<Dynamic>) {
        return new Bullet(this, collisionContainer, spriteContainer, opts);
      });

    asteroidPool = new Deadpool
      (function(opts:Array<Dynamic>) {
        return new Asteroid(this, collisionContainer, spriteContainer, opts);
      });

    new Player(this, collisionContainer, spriteContainer);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function newBullet(x:Float, y:Float, xvel:Float, yvel:Float):Void
  {
    bulletPool.newObject([x, y, xvel, yvel]);
    // end newBullet
  }

  //------------------------------------------------------------
  public function newAsteroid():Void
  {
    asteroidPool.newObject();
    // end newAsteroid
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function update():Void
  {
    if (Keyboard.isKeyPressed(Keyboard.T)) {
      trace("Time " + TimeUtils.getHumanTime(time) + " (" + time + "); " +
            entityCount + " entities; " +
            spriteContainer.instanceCount + " sprites");
    }

    if (Keyboard.isKeyPressed(Keyboard.A)) {
      newAsteroid();
    }

    collisionContainer.collide();

    // end update
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  static public function main()
  {
    nme.ui.Mouse.hide();

    nme.Lib.current.stage.align = StageAlign.TOP_LEFT;
    nme.Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

    var game:RocketHaxeBasicGame = new RocketHaxeBasicGame(640, 480);
    nme.Lib.current.stage.addChild(game);

    #if flash
      new DebugConsole();
    #end

    nme.Lib.current.stage.addChild
      (new com.rocketshipgames.haxe.debug.FPSDisplay(0xffffff, 540));

    // end main
  }

  // end RocketHaxeBasicGame
}
