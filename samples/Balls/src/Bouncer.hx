package;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.physics.Kinematics2DComponent;
import com.rocketshipgames.haxe.physics.RigidBody2DComponent;

import com.rocketshipgames.haxe.gfx.displaylist.DisplayListGraphicComponent;

import com.rocketshipgames.haxe.physics.Bounds2DComponent;


class Bouncer
  extends com.rocketshipgames.haxe.component.ComponentContainer
{

  public static var SOLID:Int = 1;

  public static var count:Int;

  private static var color = 0xFFFF00;

  private var radius:Float;
  private var mass:Float;


  public function new():Void
  {
    super();


    //-- Every 1st and 2nd Bouncer is small, every 3rd and 4th large.
    radius = 5;
    mass = 1;
    if (count != 0 && (count % 4 == 2 || count % 4 == 3)) {
      radius = 50;
      mass = 10;
    }

    //-- Every fourth shape we alternate colors
    if (count % 4 == 0) {
      if (color == 0xFF0000)
        color = 0xFFFF00;
      else
        color = 0xFF0000;
    }

    //-- Add basic position and movement
    add(Kinematics2DComponent.create
        ({ x: Display.width/2, y: -radius,
            xvel: (Math.random()*400)-200, yvel: 0,
            //xvel: 200, yvel: 0,
            xvelMin: 2, yvelMin: 2,
            yacc: 2000, xdrag: 20}));


    //-- Add descriptions of this object's physical and graphical shape
    if (count % 2 == 0) {

      //-- Every other shape is a circle
      add(RigidBody2DComponent.newCircleBody(radius, SOLID, SOLID, {mass: mass}));

      //-- Add a graphical Flash Shape representation to the Bouncer.
      //-- If there were more than one, e.g., for different panels on
      //-- the UI, the shape can be optionally tagged.
      var shape = new flash.display.Shape();
      shape.graphics.lineStyle(1);
      shape.graphics.beginFill(color);
      shape.graphics.drawCircle(0, 0, radius);
      shape.graphics.endFill();
      add(new DisplayListGraphicComponent(shape));

    } else {

      //-- And every other shape a box
      add(RigidBody2DComponent.newBoxBody(radius*2, radius*2, 1, 1, {mass: mass}));

      var shape = new flash.display.Shape();
      shape.graphics.lineStyle(1);
      shape.graphics.beginFill(color);
      shape.graphics.drawRect(-radius, -radius, radius*2, radius*2);
      shape.graphics.endFill();
      add(new DisplayListGraphicComponent(shape));

    }


    //-- If the ball is placed within bounds, respond to hitting them.
    //-- The debugging output trace won't show in a web browser.
    signals.add
      (Bounds2DComponent.SIG_BOUNDS2D,
       function(SignalID, opt:Dynamic):Bool {
        var s:Bounds2DSignalData = opt;

        if (s == BOUNDS_RIGHT)
          trace("RIGHT");

        return false;
      });


    //-- Track how many bouncers have been created
    count++;

    // end new
  }

  // end Bouncer
}
