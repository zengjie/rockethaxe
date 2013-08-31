package;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.RigidBody2DComponent;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.physics.Bounds2DComponent;


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public static var count:Int;

  var radius:Float;
  var mass:Float;
  var rubber:Float;

  public function new():Void
  {
    super();


    //-- Add basic position and movement
    add(new Kinematics2DComponent
        ({ x: 0, y: 0, xvel: 200, yvel: 0, yacc: 2000, xdrag: 200 }));

    //-- Add a description of this object's physical shape
    if (count % 2 <= 0) {
      radius = 50;
      mass = 20;
      rubber = 0.75;
    } else {
      radius = 5;
      mass = 1;
      rubber = 0.75;
    }

    var body = RigidBody2DComponent.newCircleBody(radius, 1, 1);
    body.mass = mass;
    body.restitution = rubber;
    add(body);

    //-- Add a graphical Flash Shape representation to the Bouncer.
    //-- If there were more than one, e.g., for different panels on
    //-- the UI, the shape can be optionally tagged.
    var shape = new flash.display.Shape();
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawCircle(0, 0, radius);
    shape.graphics.endFill();
    add(new DisplayListGraphicComponent(shape));


    //-- If the ball is placed within bounds, respond to hitting them
    signals.add(Bounds2DComponent.SIG_BOUNDS2D,
                function(SignalID, opt:Dynamic):Bool
                {
                  var s:Bounds2DSignalData = opt;

                  if (s == BOUNDS_RIGHT)
                    trace("RIGHT");

                  return false;
                });

    count++;

    // end new
  }

  // end Bouncer
}
