package com.rocketshipgames.haxe.world.behaviors;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.gfx.Viewport;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.Position2D;


class ViewportTrackerComponent
  implements Component
{

  private var viewport:Viewport;
  private var position:Position2D;

  private var active:Bool;


  //--------------------------------------------------------------------
  private function new(viewport:Viewport):Void
  {
    this.viewport = viewport;
    // end new
  }

  public static function create(viewport:Viewport, ?opts:Dynamic):ViewportTrackerComponent
  {
    var x = new ViewportTrackerComponent(viewport);
    x.activate(opts);
    return x;
    // end create
  }


  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    active = true;
  }

  public function deactivate():Void
  {
    active = false;
  }


  //----------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    position = cast(container.find(PhysicsCapabilities.CID_POSITION2D),
                    Position2D);
    // end attach
  }

  public function detach():Void {}


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    if (!active)
      return;

    if (viewport.x > position.x-25)
      viewport.x = position.x-25;
    else if (viewport.x+viewport.width < position.x+25)
      viewport.x = (position.x+25)-viewport.width;

    if (viewport.y > position.y-25)
      viewport.y = position.y-25;
    else if (viewport.y+viewport.height < position.y+25)
      viewport.y = (position.y+25)-viewport.height;

    // end update
  }

  // end ViewportTrackerComponent
}
