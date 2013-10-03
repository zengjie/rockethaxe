package com.rocketshipgames.haxe.gfx;

import flash.events.MouseEvent;

import com.rocketshipgames.haxe.component.ComponentContainer;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.world.behaviors.ViewportTrackerComponent;

import com.rocketshipgames.haxe.physics.Extent2D;


class Viewport
{

  //----------------------------------------------------
  public var x(default,null):Float;
  public var y(default,null):Float;

  public var width(default,null):Float;
  public var height(default,null):Float;

  public var pixelsPerMeter(default,null):Float;


  //----------------------------------------------------
  private var token:Int;

  private var bounds:Extent2D;

  private var dragging:Bool;
  private var mousex:Float;
  private var mousey:Float;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(?opts:Dynamic):Void
  {

    x = y = 0.0;

    width = Display.width/Display.defaultPixelsPerMeter;
    height = Display.height/Display.defaultPixelsPerMeter;

    pixelsPerMeter = Display.defaultPixelsPerMeter;

    activate(opts);

    // end new
  }

  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {

    if (opts == null)
      return;

    var d:Dynamic;
    if ((d = Reflect.field(opts, "bounds")) != null) {
      bounds = cast(d, Extent2D);
    }

    if ((d = Reflect.field(opts, "drag")) != null) {
      if ((Std.is(d, String)) ? (d=="true") : d)
        enableDrag();
    }

    // end activate
  }

  //----------------------------------------------------
  public function setBounds(bounds:Extent2D):Void
  {
    this.bounds = bounds;
    // end setBounds
  }

  //----------------------------------------------------
  public function set(x:Float, y:Float):Void
  {

    // This should actually be done with a more generic locking
    // mechanism rather than enabling just dragging to lock other
    // components out, but it's reasonable for now.

    if (!dragging)
      set_(x, y);

    // end set
  }

  private function set_(x:Float, y:Float):Void
  {

    if (bounds != null) {
      if (x < bounds.left())
        x = bounds.left();
      else if (x + width > bounds.right())
        x = bounds.right() - width;

      if (y < bounds.top())
        y = bounds.top();
      else if (y + height > bounds.bottom())
        y = bounds.bottom() - height;
    }

    this.x = x;
    this.y = y;

    // end set_
  }

  //----------------------------------------------------
  public function track(entity:ComponentContainer, ?opts:Dynamic):Void
  {
    entity.add(ViewportTrackerComponent.create(this, opts));
    // end track
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  private function onMouseDown(e:MouseEvent):Void
  {
    dragging = true;
    mousex = e.localX;
    mousey = e.localY; 
  }

  private function onMouseUp(e:MouseEvent):Void
  {
    dragging = false;
  }

  private function onMouseMove(e:MouseEvent):Void
  {

    if (dragging) {
      // These are substractions because we move the viewport in
      // the opposite direction, as if dragging the map as opposed
      // to moving the view.

      set_(x - (e.localX-mousex)/pixelsPerMeter,
           y - (e.localY-mousey)/pixelsPerMeter);

      mousex = e.localX;
      mousey = e.localY;
    }

    // end onMouseMove
  }


  //----------------------------------------------------
  public function enableDrag():Void
  {

    flash.Lib.current.stage.addEventListener
      (MouseEvent.MOUSE_DOWN, onMouseDown);

    flash.Lib.current.stage.addEventListener
      (MouseEvent.MOUSE_UP, onMouseUp);

    flash.Lib.current.stage.addEventListener
      (MouseEvent.MOUSE_MOVE, onMouseMove);

    // end enableDrag
  }

  public function disableDrag():Void
  {
    flash.Lib.current.stage.removeEventListener
      (MouseEvent.MOUSE_DOWN, onMouseDown);

    flash.Lib.current.stage.removeEventListener
      (MouseEvent.MOUSE_UP, onMouseUp);

    flash.Lib.current.stage.removeEventListener
      (MouseEvent.MOUSE_MOVE, onMouseMove);

    // end disableDrag
  }

  // end Viewport
}
