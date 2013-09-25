package com.rocketshipgames.haxe.gfx.displaylist;

import flash.display.Sprite;
import flash.display.DisplayObject;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;
import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.CapabilityID;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.Position2D;

import com.rocketshipgames.haxe.gfx.Viewport;


class DisplayListGraphicComponent
  implements Component
{

  public static var CID:CapabilityID =
    ComponentContainer.hashID("display-object");


  //----------------------------------------------------
  private var root:Sprite;
  private var graphic:DisplayObject;

  private var position:Position2D;

  private var active:Bool;

  private var tag:CapabilityID;


  //--------------------------------------------------------------------
  public function new(graphic:DisplayObject,
                      ?tag:CapabilityID):Void
  {
    this.graphic = graphic;
    active = true;

    if (tag != ComponentContainer.CID_NULL)
      this.tag = tag;
    else
      this.tag = CID;

    // end new
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
    if (root != null)
      root.addChild(graphic);
    active = true;
  }

  public function deactivate():Void
  {
    active = false;
    if (root != null)
      root.removeChild(graphic);
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void { }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function setRoot(root:Sprite):Void
  {
    this.root = root;
    if (active)
      activate();
    // end setRoot
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(viewport:Viewport):Void
  {
    graphic.x = Math.floor((position.x - viewport.x)*viewport.pixelsPerMeter);
    graphic.y = Math.floor((position.y - viewport.y)*viewport.pixelsPerMeter);
  }

  // end DisplayListGraphicComponent
}
