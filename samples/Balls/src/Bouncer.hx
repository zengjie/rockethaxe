package;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.RigidBody2DComponent;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.physics.Bounds2DComponent;


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public function new():Void
  {
    super();


    //-- Add basic position and movement
    add(new Kinematics2DComponent({ xvel: 200, yvel: 200}));

    //-- Add a description of this object's physical shape
    add(RigidBody2DComponent.newCircleBody(50));

    //-- Add a graphical Flash Shape representation to the Bouncer
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
