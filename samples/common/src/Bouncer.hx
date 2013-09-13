package;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;
import com.rocketshipgames.haxe.physics.core2d.Bounds2DComponent;


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

  public static function createCircle(radius:Float, ?opts):Bouncer
  {
    var x = new Bouncer();

    opts = defaultOpts(opts);

    x.add(RigidBody2DComponent.newCircleBody(radius, opts));

    var shape = new flash.display.Shape();
    shape.graphics.lineStyle(1);
    shape.graphics.beginFill(Reflect.field(opts, "color"));
    shape.graphics.drawCircle(0, 0, radius);
    shape.graphics.endFill();
    x.add(new DisplayListGraphicComponent(shape));

    return x;
  }

  public static function createBox(width:Float, height:Float, ?opts:Dynamic):Bouncer
  {
    var x = new Bouncer();

    opts = defaultOpts(opts);

    x.add(RigidBody2DComponent.newBoxBody(width, height, opts));

    var shape = new flash.display.Shape();
    shape.graphics.lineStyle(1);
    shape.graphics.beginFill(Reflect.field(opts, "color"));
    shape.graphics.drawRect(-width/2, -height/2, width, height);
    shape.graphics.endFill();
    x.add(new DisplayListGraphicComponent(shape));

    return x;
  }

  private static function defaultOpts(?opts:Dynamic):Dynamic
  {
    if (opts == null)
      opts = {};

    var d:Dynamic;
    if ((d = Reflect.field(opts, "color")) == null) {
      Reflect.setField(opts, "color", 0xFF0000);
    }

    if (opts.gravity)
      opts.yacc = 2000;

    opts.xvelMin = 2;
    opts.yvelMin = 2;
    
    opts.collidesAs = SOLID;
    opts.collidesWith = SOLID;

    return opts;
  }


  public function placeBounds(action:BouncerBoundsAction):Void
  {
    var bounds = new Bounds2DComponent();
    bounds.setBounds(0, 0,
                     Display.width, Display.height);

    switch (action) {
    case BOUNCE:
      bounds.offBoundsLeft = bounds.bounceLeft;
      bounds.offBoundsRight = bounds.bounceRight;
      bounds.offBoundsTop = bounds.bounceTop;
      bounds.offBoundsBottom = bounds.bounceBottom;

    case REMOVE:
      bounds.offBoundsLeft = bounds.offBoundsRight
        = bounds.offBoundsBottom = offScreen;
    }

    add(bounds);
    // end placeBounds
  }


  public function offScreen():Void
  {
    //-- Remove this Bouncer from the world
    trace("Removing bouncer.");
    if (container == null)
      trace("This bouncer has already been removed!");

    container.remove();
  }

  // end Bouncer
}
