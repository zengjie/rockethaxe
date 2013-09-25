package;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;
import com.rocketshipgames.haxe.physics.core2d.Bounds2DComponent;


enum BouncerShape {
  CIRCLE;
  BOX;
}

enum BouncerBoundsAction {
  BOUNCE;
  REMOVE;
}


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public static var SOLID:Int = 1;


  private function new():Void
  {
    super();
    // end new
  }


  public static function create(?opts:Dynamic):Bouncer
  {

    var x = new Bouncer();


    if (opts == null)
      opts = {};

    var d:Dynamic;
    if ((d = Reflect.field(opts, "color")) == null) {
      Reflect.setField(opts, "color", 0xFF0000);
    }

    if ((d = Reflect.field(opts, "type")) == null) {
      Reflect.setField(opts, "type", BOX);
    }

    var pixelsPerMeter:Float = 24;
    if ((d = Reflect.field(opts, "ppm")) != null) {
      pixelsPerMeter = d;
    }

    if (opts.gravity)
      opts.yacc = 83;

    opts.xvelMin = 0.08;
    opts.yvelMin = 0.08;
    
    opts.collidesAs = SOLID;
    opts.collidesWith = SOLID;


    //----------------------------------------------------------
    switch (cast(Reflect.field(opts, "type"), BouncerShape)) {
    case CIRCLE:

      var radius:Float;
      var d:Dynamic;
      if ((d = Reflect.field(opts, "radius")) == null)
        radius = 1;
      else
        radius = d;

      x.add(RigidBody2DComponent.newCircleBody(radius, opts));

      var shape = new flash.display.Shape();
      shape.graphics.lineStyle(1);
      shape.graphics.beginFill(Reflect.field(opts, "color"));
      shape.graphics.drawCircle(0, 0, radius*pixelsPerMeter);
      shape.graphics.endFill();
      x.add(new DisplayListGraphicComponent(shape));


    case BOX:
      var width:Float = 1;
      var height:Float = 1;

      var d:Dynamic;
      if ((d = Reflect.field(opts, "width")) != null)
        width = d;

      if ((d = Reflect.field(opts, "height")) != null)
        height = d;

      x.add(RigidBody2DComponent.newBoxBody(width, height, opts));

      var shape = new flash.display.Shape();
      shape.graphics.lineStyle(1);
      shape.graphics.beginFill(Reflect.field(opts, "color"));
      shape.graphics.drawRect
        (Math.floor((-width/2)*pixelsPerMeter),
         Math.floor((-height/2)*pixelsPerMeter),
         Math.floor(width*pixelsPerMeter), Math.floor(height*pixelsPerMeter));
      shape.graphics.endFill();
      x.add(new DisplayListGraphicComponent(shape));

    }

    return x;

    // end create
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function placeBounds(action:BouncerBoundsAction):Void
  {

    var bounds = new Bounds2DComponent();
    bounds.setBounds(0, 0,
                     Display.width, Display.height);

    switch (action) {
    case BOUNCE:
      bounds.response = bounds.bounce;
      bounds.containLeft = bounds.containRight =
        bounds.containTop = bounds.containBottom = true;

    case REMOVE:
      bounds.response = offScreen;

    }

    add(bounds);

    // end placeBounds
  }


  public function offScreen(hit:Int):Void
  {

    //-- If only the top was hit, do nothing
    if (hit == Bounds2DComponent.BOUNDS_TOP)
      return;

    //-- Otherwise, remove this Bouncer from the world
    trace("Removing bouncer.");
    if (container == null)
      trace("This bouncer has already been removed!");

    container.remove();

    // end offScreen
  }

  // end Bouncer
}
