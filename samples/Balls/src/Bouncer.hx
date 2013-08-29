package;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.RigidBody2DComponent;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.physics.Bounds2DComponent;


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public static var count:Int;


  public function new():Void
  {
    super();


    //-- Add basic position and movement
    //    if (count < 1)
    //      add(new Kinematics2DComponent({ x: 400, y: 400, xvel: 0, yvel: 0}));
      //    else
      add(new Kinematics2DComponent({ x: 0, y: 0, xvel: 50, yvel: 200}));
      //    count++;

    //-- Add a description of this object's physical shape
    add(RigidBody2DComponent.newCircleBody(25, 1, 1));

    //-- Add a graphical Flash Shape representation to the Bouncer.
    //-- If there were more than one, e.g., for different panels on
    //-- the UI, the shape can be optionally tagged.
    var shape = new flash.display.Shape();
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawCircle(0, 0, 25);
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

    // end new
  }

  // end Bouncer
}
