package com.rocketshipgames.haxe.world.behaviors;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.gfx.Viewport;

import com.rocketshipgames.haxe.physics.PhysicsCapabilities;
import com.rocketshipgames.haxe.physics.Extent2D;


class ViewportTrackerComponent
  implements Component
{

  private var viewport:Viewport;
  private var extent:Extent2D;

  private var active:Bool;

  private var marginLeft:Float;
  private var marginRight:Float;
  private var marginTop:Float;
  private var marginBottom:Float;

  private var left:Float;
  private var right:Float;
  private var top:Float;
  private var bottom:Float;


  //--------------------------------------------------------------------
  private function new(viewport:Viewport):Void
  {

    this.viewport = viewport;

    marginLeft = marginRight = marginTop = marginBottom = 0.0;

    left = right = top = bottom = 0.0;

    // end new
  }

  public static function create(viewport:Viewport,
                                ?opts:Dynamic):ViewportTrackerComponent
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

    if (opts == null)
      return;


    var d:Dynamic;
    if ((d = Reflect.field(opts, "margin")) != null) {
      marginLeft = marginRight = marginTop = marginBottom =
        (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    if ((d = Reflect.field(opts, "marginLeft")) != null) {
      marginLeft = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }
    if ((d = Reflect.field(opts, "marginRight")) != null) {
      marginRight = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }
    if ((d = Reflect.field(opts, "marginTop")) != null) {
      marginTop = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }
    if ((d = Reflect.field(opts, "marginBottom")) != null) {
      marginBottom = (Std.is(d, String)) ? Std.parseFloat(d) : d;
    }

    // end activate
  }

  public function deactivate():Void
  {
    active = false;
  }


  //----------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    extent = cast(container.find(PhysicsCapabilities.CID_EXTENT2D),
                    Extent2D);

    left = extent.left();
    right = extent.right();
    top = extent.top();
    bottom = extent.bottom();

    // end attach
  }

  public function detach():Void {}


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {

    if (!active)
      return;

    if (left != extent.left() || right != extent.right() ||
        top != extent.top() || bottom != extent.bottom()) {

      left = extent.left();
      right = extent.right();
      top = extent.top();
      bottom = extent.bottom();

      var x = viewport.x;
      var y = viewport.y;

      if (x + viewport.width < extent.right() + marginRight)
        x = extent.right() + marginRight - viewport.width;
      else if (x > extent.left() - marginLeft)
        x = extent.left() - marginLeft;

      if (y + viewport.height < extent.bottom() + marginBottom)
        y = extent.bottom() + marginBottom - viewport.height;
      else if (y > extent.top() - marginTop)
        y = extent.top() - marginTop;

      viewport.set(x, y);
    }

    // end update
  }

  // end ViewportTrackerComponent
}
