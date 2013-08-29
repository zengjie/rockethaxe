package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.ComponentHandle;


enum RigidBody2DType {
  RIGID_CIRCLE;
  RIGID_RECTANGLE;
}


class RigidBody2DComponent
  implements Extent2D
  implements com.rocketshipgames.haxe.component.Component
             
{

  public static var CID:
    com.rocketshipgames.haxe.component.CapabilityID =
    com.rocketshipgames.haxe.component.ComponentContainer.hashID("rigid-body-2d");


  //------------------------------------------------------------
  public var type(default,null):RigidBody2DType;

  public var diameter(default,null):Float;

  public var width(default,null):Float;
  public var height(default,null):Float;

  public var mass:Float;


  //----------------------------------------------------
  private var position:Position2D;


  //--------------------------------------------------------------------
  private function new():Void
  {
    mass = 1.0;
    // end new
  }

  //----------------------------------------------------
  public static function newCircleBody(diameter:Float):RigidBody2DComponent
  {
    var x = new RigidBody2DComponent();
    x.type = RIGID_CIRCLE;
    x.diameter = diameter;

    x.width = diameter;
    x.height = diameter;

    return x;
    // end newCircleBody
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function attach(container:ComponentHandle):Void
  {
    container.claim(PhysicsCapabilities.CID_EXTENT2D);
    container.claim(CID);

    position =
      cast(container.find(PhysicsCapabilities.CID_POSITION2D),
           Position2D);

    // end attach
  }

  public function detach():Void
  {
  }


  //------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //------------------------------------------------------------------
  public function update(millis:Int):Void
  {
    // end update
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function left():Float
  {
    return position.x - width/2;
  }

  public function right():Float
  {
    return position.x + width/2;
  }

  public function top():Float
  {
    return position.y - height/2;
  }

  public function bottom():Float
  {
    return position.y + height/2;
  }

  // end RigidBody2DComponent
}