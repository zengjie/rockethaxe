package com.rocketshipgames.haxe.gfx.displaylist;

import flash.display.Sprite;
import flash.display.DisplayObject;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;

import com.rocketshipgames.haxe.gfx.Viewport;


class DisplayListGraphicComponent
  implements Component
{

  private var root:Sprite;
  private var graphic:DisplayObject;

  private var kinematics:Kinematics2DComponent;


  //--------------------------------------------------------------------
  public function new(root:Sprite, graphic:DisplayObject):Void
  {
    this.root = root;
    this.graphic = graphic;
    // end new
  }


  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    kinematics =
      cast(containerHandle.find(Kinematics2DComponent.CID_KINEMATICS2D),
           Kinematics2DComponent);

    activate();
  }

  public function detach():Void
  {
    deactivate();
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    root.addChild(graphic);
  }

  public function deactivate():Void
  {
    root.removeChild(graphic);
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void { }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(viewport:Viewport):Void
  {
    graphic.x = kinematics.x - viewport.x;
    graphic.y = kinematics.y - viewport.y;
  }

  // end DisplayListGraphicComponent
}
