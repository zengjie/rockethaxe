package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.CapabilityID;


import com.rocketshipgames.haxe.world.behaviors.BehaviorCapabilities;
import com.rocketshipgames.haxe.world.behaviors.Facing2D;
import com.rocketshipgames.haxe.world.ScreenDirection2D;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.Kinematics2D;


class FacingGameSpriteComponent
  extends GameSpriteComponent
{

  private var facing:Facing2D;
  private var prevFacing:ScreenDirection2D;

  private var kinematics:Kinematics2D;

  private var leftMove:GameSpriteAnimation;
  private var rightMove:GameSpriteAnimation;
  private var upMove:GameSpriteAnimation;
  private var downMove:GameSpriteAnimation;

  /*
  private var leftIdle:GameSpriteAnimation;
  private var rightIdle:GameSpriteAnimation;
  private var upIdle:GameSpriteAnimation;
  private var downIdle:GameSpriteAnimation;
  */

  private var idle:Bool;

  //--------------------------------------------------------------------
  public function new(sprite:GameSprite, ?tag:CapabilityID, ?idle:Bool):Void
  {

    super(sprite, tag);

    leftMove = sprite.animation("left");
    rightMove = sprite.animation("right");
    upMove = sprite.animation("up");
    downMove = sprite.animation("down");

    this.idle = idle;

    /*
    if (idle) {
      leftIdle = sprite.animation("idle-left");
      rightIdle = sprite.animation("idle-right");
      upIdle = sprite.animation("idle-up");
      downIdle = sprite.animation("idle-down");
    }
    */

    // end new
  }


  //--------------------------------------------------------------------
  public override function attach(container:ComponentHandle):Void
  {

    facing =
      cast(container.find(BehaviorCapabilities.CID_FACING2D), Facing2D);

    if (idle)
      kinematics =
        cast(container.find(PhysicsCapabilities.CID_KINEMATICS2D), Kinematics2D);

    super.attach(container);
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public override function render(viewport:Viewport):Void
  {

    if (facing.facing != prevFacing ||
        (idle && (kinematics.xvel != 0 || kinematics.yvel != 0))) {
      switch (facing.facing) {
      case LEFT:
        //      if (idle && kinematics.xvel == 0 && kinematics.xacc == 0)
        //        play(leftIdle);
        //      else
        play(leftMove);

      case RIGHT:
        //      if (idle && kinematics.xvel == 0 && kinematics.xacc == 0)
        //        play(rightIdle);
        //      else
        play(rightMove);

      case UP:
        //        if (idle && kinematics.yvel == 0 && kinematics.yacc == 0)
        //          play(upIdle);
        //        else
        play(upMove);

      case DOWN:
        //        if (idle && kinematics.yvel == 0 && kinematics.yacc == 0)
        //          play(downIdle);
        //        else
        play(downMove);
      }

      prevFacing = facing.facing;
    }

    super.render(viewport);

    // end render
  }

  // end FacingGameSpriteComponent
}
