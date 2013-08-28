package;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.component.SignalDispatcher;

import com.rocketshipgames.haxe.physics.SweepScanCollisionContainer;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.Bounds2DComponent;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicsContainer;

import com.rocketshipgames.haxe.device.Display;


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public function new(collisions:SweepScanCollisionContainer,
                      graphics:DisplayListGraphicsContainer):Void
  {
    super();

    var kinematics = new Kinematics2DComponent
      ({ xvel: 200, yvel: 200});
    add(kinematics);

    var bounds = new Bounds2DComponent();
    bounds.setBounds(BOUNDS_DETECT,
                     25, 25,
                     Display.width-25, Display.height-25);
    bounds.offBoundsLeft = function() { bounds.bounceLeft(); }
    bounds.offBoundsRight = bounds.bounceRight;
    bounds.offBoundsTop = bounds.bounceTop;
    bounds.offBoundsBottom = bounds.bounceBottom;
    bounds.enableSignal();
    add(bounds);

    collisions.addCircleBody(this);

    signals.add(Bounds2DComponent.SIG_BOUNDS2D,
                function(SignalID, opt:Dynamic):Bool
                {
                  var s = cast(opt, Bounds2DSignalData);
                  if (s == BOUNDS_RIGHT) {
                    trace("RIGHT");
                  }
                  return false;
                });

    //-- Create and add a Flash Shape object to draw the Bouncer
    var shape = new flash.display.Shape();
    shape.graphics.beginFill(0xFF0000);
    shape.graphics.drawCircle(0, 0, 25);
    shape.graphics.endFill();

    graphics.addDisplayListGraphic(this, shape);

    // end new
  }

  // end Bouncer
}
