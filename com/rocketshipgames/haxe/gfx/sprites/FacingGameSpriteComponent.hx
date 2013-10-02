package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.CapabilityID;


import com.rocketshipgames.haxe.world.behaviors.BehaviorCapabilities;
import com.rocketshipgames.haxe.world.behaviors.Facing2D;


class FacingGameSpriteComponent
  extends GameSpriteComponent
{

  private var facing:Facing2D;

  private var left:Int;
  private var right:Int;
  private var up:Int;
  private var down:Int;

  //--------------------------------------------------------------------
  public function new(sprite:GameSprite, ?tag:CapabilityID):Void
  {
    super(sprite, tag);

    left = sprite.keyframe("left");
    right = sprite.keyframe("right");
    up = sprite.keyframe("up");
    down = sprite.keyframe("down");

    trace("FACING New");

    // end new
  }


  //--------------------------------------------------------------------
  public override function attach(container:ComponentHandle):Void
  {

    facing =
      cast(container.find(BehaviorCapabilities.CID_FACING2D), Facing2D);

    super.attach(container);
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public override function render(viewport:Viewport):Void
  {

    trace("Render");

    switch (facing.facing) {
    case LEFT:
      trace("Facing is left");
      show(left);

    case RIGHT:
      trace("Facing is right");
      show(right);

    case UP:
      trace("Facing is up");
      show(up);

    case DOWN:
      trace("Facing is down");
      show(down);
    }

    super.render(viewport);

    // end render
  }

  // end FacingGameSpriteComponent
}
