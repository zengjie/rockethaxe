package;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.RigidBody2DComponent;
import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;
import com.rocketshipgames.haxe.physics.Bounds2DComponent;


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public static var CIRCLE:Int = 0;
  public static var BOX:Int = 1;

  public static var SOLID:Int = 1;


  public function new(type:Int, radius:Float, mass:Float,
                      x:Float, y:Float, gravity:Bool=true):Void
  {
    super();

    //-- Add basic position and movement
    add(Kinematics2DComponent.create
        ({ x: x, y: y,
            xvel: 0, yvel: 0,
            xvelMin: 2, yvelMin: 2,
            yacc: (gravity)?2000:0, xdrag: 20}));


    //-- Add descriptions of this object's physical and graphical shape
    if (type == CIRCLE) {

      add(RigidBody2DComponent.newCircleBody(radius, SOLID, SOLID, {mass: mass}));

      var shape = new flash.display.Shape();
      shape.graphics.lineStyle(1);
      shape.graphics.beginFill(0xFF0000);
      shape.graphics.drawCircle(0, 0, radius);
      shape.graphics.endFill();
      add(new DisplayListGraphicComponent(shape));

    } else {

      add(RigidBody2DComponent.newBoxBody(radius*2, radius*2, 1, 1, {mass: mass}));

      var shape = new flash.display.Shape();
      shape.graphics.lineStyle(1);
      shape.graphics.beginFill(0xFF0000);
      shape.graphics.drawRect(-radius, -radius, radius*2, radius*2);
      shape.graphics.endFill();
      add(new DisplayListGraphicComponent(shape));

    }

    var bounds = new Bounds2DComponent();
    bounds.setBounds(-radius*2, -radius*2,
                     Display.width+radius*2, Display.height+radius*2);
    bounds.offBoundsLeft = bounds.offBoundsRight = 
      bounds.offBoundsTop = bounds.offBoundsBottom = offScreen;
    add(bounds);

    // end new
  }

  public function offScreen():Void
  {
    //-- Remove this Bouncer from the world
    trace("Removing bouncer.");
    container.remove();
  }


  // end Bouncer
}
