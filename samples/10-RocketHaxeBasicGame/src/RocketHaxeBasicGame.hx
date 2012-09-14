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

// Provides a helper to configure the screen coordinate system, as
// well as the screen dimensions prescribed by the build.
import com.rocketshipgames.haxe.gfx.Screen;


import com.rocketshipgames.haxe.World;
import com.rocketshipgames.haxe.Timer;


import com.rocketshipgames.haxe.gfx.GameSpriteContainer;

import com.rocketshipgames.haxe.physics.CollisionContainer;

import com.rocketshipgames.haxe.ds.Deadpool;

import com.rocketshipgames.haxe.ui.Keyboard;

import com.rocketshipgames.haxe.util.TimeUtils;

import com.rocketshipgames.haxe.debug.DebugConsole;
import com.rocketshipgames.haxe.debug.FPSDisplay;

import com.rocketshipgames.haxe.sfx.SoundEffect;
import com.rocketshipgames.haxe.sfx.SoundEffectGroup;

class RocketHaxeBasicGame
  extends com.rocketshipgames.haxe.GameLoop
{

  public static inline var COLLIDES_PLAYER:Int = 1;
  public static inline var COLLIDES_BULLET:Int = 2;
  public static inline var COLLIDES_ASTEROID:Int = 4;

  public var mute:Bool;

  public var sounds:SoundEffectGroup;

  //------------------------------------------------------------
  private var spriteContainer:GameSpriteContainer;
  private var collisionContainer:CollisionContainer;

  private var bulletPool:Deadpool<Bullet>;
  private var asteroidPool:Deadpool<Asteroid>;

  private var asteroidTimer:Timer;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(?width:Float, ?height:Float):Void
  {
    super(width, height);

    addGraphicsContainer(spriteContainer =
                         new GameSpriteContainer
                         (Assets.getBitmapData("assets/sprites.png"),
                          Assets.getText("assets/sprites.xml")));

    collisionContainer =
      new com.rocketshipgames.haxe.physics.collisions.SweepScanCollisionContainer();

    mute = true;
    sounds = new SoundEffectGroup();
    sounds.setMute(mute);

    bulletPool = new Deadpool
      (function(opts:Array<Dynamic>) {
        return new Bullet(this, collisionContainer, spriteContainer, opts);
      });

    asteroidPool = new Deadpool
      (function(opts:Array<Dynamic>) {
        return new Asteroid(this, collisionContainer, spriteContainer, opts);
      });

    asteroidTimer = addTimer(new Timer(newAsteroid, 250, 500, true));

    addSignal
      ("player-died",
       function(id:String, msg:Dynamic):Bool
       { addTimer(new Timer(newPlayer, 1000));
         trace("You died!  Respawn in 1sec...");
         return false; });

    newPlayer();

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
  public function newAsteroid():Bool
  {
    if (Asteroid.numAsteroids < Asteroid.maxAsteroids)
      asteroidPool.newObject();
    return false;
    // end newAsteroid
  }

  //------------------------------------------------------------
  public function newPlayer():Bool
  {
    new Player(this, collisionContainer, spriteContainer,
               [{ killSignal: "player-died" }]);
    return false;
    // end playerDied
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

    if (Keyboard.isKeyPressed(Keyboard.EQUAL)) {
      Asteroid.maxAsteroids += 10;
      asteroidTimer.minInterval >> 2;
      asteroidTimer.maxInterval >> 2;

      while (Asteroid.numAsteroids < Asteroid.maxAsteroids)
        newAsteroid();

      trace("Density increasing!  (now " + Asteroid.maxAsteroids + "max )");
    }
    if (Keyboard.isKeyPressed(Keyboard.MINUS)) {
      Asteroid.maxAsteroids -= 10;
      asteroidTimer.minInterval << 2; 
      asteroidTimer.maxInterval << 2;
      trace("Density decreasing...  (now " + Asteroid.maxAsteroids + "max )");
    }

    if (Keyboard.isKeyPressed(Keyboard.M)) {
      mute = !mute;
      sounds.setMute(mute);
    }

    // Check for collisions and apply responses
    collisionContainer.collide();

    // end update
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  static public function main()
  {

    //-- Do some basic setup and initialization

    // Configure the stage to use standard game conventions.
    Screen.configureStandard();

    // Play a zero volume sound to get the sound system going.
    new SoundEffect(Assets.getSound("assets/explosion.wav"), {volume:0}).play();

    // Turn off the mouse.
    com.rocketshipgames.haxe.ui.Mouse.disable();


    //-- Create the game and put it on stage!
    var game:RocketHaxeBasicGame = new RocketHaxeBasicGame();
    nme.Lib.current.stage.addChild(game);


    //-- Setup some debugging stuff

    // Change the display of trace() so that messages timeout
    new com.rocketshipgames.haxe.debug.DebugConsole();

    // Add FPS display
    new com.rocketshipgames.haxe.debug.FPSDisplay
      (0xffffff,
       Screen.width,
       com.rocketshipgames.haxe.gfx.HorizontalAlignment.RIGHT);


    //-- Explain how to play
    trace("Arrows move, space shoots");
    trace("Press T for entity count");
    trace("Press +/- to launch asteroids");
    trace("Press M to toggle sound; default is " +
          ((game.mute)?"":"un") + "muted");

    // end main
  }

  // end RocketHaxeBasicGame
}
