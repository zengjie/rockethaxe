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

import com.rocketshipgames.haxe.ui.Keyboard;

import com.rocketshipgames.haxe.util.TimeUtils;


class RocketHaxeBasicGame
  extends com.rocketshipgames.haxe.GameLoop
{

  //------------------------------------------------------------
  private var spriteContainer:GameSpriteContainer;
  private var collisionContainer:CollisionContainer;

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

    new Player(this, collisionContainer, spriteContainer);

    trace("Starting game...");

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function update():Void
  {
    if (Keyboard.isKeyPressed(Keyboard.F11)) {
      trace("Time " + TimeUtils.getHumanTime(time) + " (" + time + "); " +
            entityCount + " entities; " +
            spriteContainer.instanceCount + " sprites");
    }
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

//--------------------------------------------------------------------
//------------------------------------------------------------
import com.rocketshipgames.haxe.game.entities.BasicGameSpriteEntity;

import com.rocketshipgames.haxe.physics.packages.ShooterPhysicsPackage;

class Player
  extends BasicGameSpriteEntity
{

  //------------------------------------------------------------
  private static inline var ACCELERATION:Float = 2000;

  private var enginesOnFrame:Int;
  private var enginesOffFrame:Int;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(world:World,
                      collisionContainer:CollisionContainer,
                      gfxContainer:GameSpriteContainer):Void
  {

    var physics:ShooterPhysicsPackage = new ShooterPhysicsPackage(this);
    physics.xdrag = physics.ydrag = ACCELERATION/2;
    physics.xvelMin = physics.yvelMin = 2;
    physics.xvelMax = physics.yvelMax = 300;
    physics.setBounds(BOUNDS_STOP, world);
    this.physics = physics;

    super(world, collisionContainer, gfxContainer, "player");

    x = world.worldWidth/2;
    y = 3*world.worldHeight/4;

    enginesOnFrame = sprite.keyframe("engines");
    enginesOffFrame = sprite.keyframe("idle");

    // end new
  }

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

    super.update(elapsed);

    if (physics.yvel < -physics.yvelMin)
      frame = enginesOnFrame;
    else
      frame = enginesOffFrame;

    // end update
  }

  // end Player
}
