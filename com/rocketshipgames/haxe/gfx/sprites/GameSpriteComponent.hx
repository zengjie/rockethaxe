package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.CapabilityID;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.Position2D;

import com.rocketshipgames.haxe.gfx.Viewport;


class GameSpriteComponent
  implements Component
{

  public static var CID:CapabilityID =
    ComponentContainer.hashID("gamesprite");


  //----------------------------------------------------
  private var renderer:GameSpriteRenderer;
  private var spritesheet:SpritesheetContainer;

  @:allow(com.rocketshipgames.haxe.gfx.sprites.GameSpriteRenderer)
  private var layer:Int;

  @:allow(com.rocketshipgames.haxe.gfx.sprites.GameSpriteRenderer)
  private var handle:DoubleLinkedListHandle<GameSpriteComponent>;

  private var sprite:GameSprite;

  private var position:Position2D;

  private var tag:CapabilityID;

  private var frame:Int;

  private var active:Bool;


  //--------------------------------------------------------------------
  public function new(sprite:GameSprite, ?tag:CapabilityID=null):Void
  {
    active = true;

    this.sprite = sprite;
    frame = sprite.baseFrameIndex;

    if (tag != null)
      this.tag = tag;
    else
      this.tag = CID;

    // end new
  }

  @:allow(com.rocketshipgames.haxe.gfx.sprites.GameSpriteRenderer)
  private function setRenderer(renderer:GameSpriteRenderer):Void {
    this.renderer = renderer;
    spritesheet = renderer.container;
  }

  //--------------------------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    container.claim(tag);

    position =
      cast(container.find(PhysicsCapabilities.CID_POSITION2D), Position2D);

    activate();
  }

  public function detach():Void
  {
    deactivate();
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    active = true;
    if (handle == null && renderer != null)
      renderer.addComponent(this, layer);
  }

  public function deactivate():Void
  {
    active = false;

    if (handle != null)
      handle.remove();
    handle = null;
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function show(frame:Int):Void
  {
    this.frame = frame;
  }

  public function showByLabel(label:String):Int
  {
    return this.frame = sprite.keyframe(label);
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(viewport:Viewport):Void
  {
    spritesheet.drawFrame
      (Math.floor((position.x - viewport.x)*viewport.pixelsPerMeter),
       Math.floor((position.y - viewport.y)*viewport.pixelsPerMeter),
       frame);
    // end render
  }


  //------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function update(millis:Int):Void
  {
  }

  // end DisplayListGraphicComponent
}
