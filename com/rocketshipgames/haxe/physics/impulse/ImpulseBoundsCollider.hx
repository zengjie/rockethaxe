package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.physics.core2d.Bounds2DComponent;
import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;


class ImpulseBoundsCollider
  extends ImpulseCollider
{

  //------------------------------------------------------------
  public static var BOUNDS_BUFFER:Float = 1000.0;
  public static var BOUNDS_MASS:Float = 10000;
  public static var BOUNDS_RESTITUTION:Float = 0.8;

  //--------------------------------------------------------------------
  private var left:Float;
  private var top:Float;

  private var right:Float;
  private var bottom:Float;

  private var leftBody:RigidBody2DComponent;
  private var rightBody:RigidBody2DComponent;
  private var topBody:RigidBody2DComponent;
  private var bottomBody:RigidBody2DComponent;

  private var manifold:ImpulseManifold;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {
    super();

    setBounds(0, 0, Display.width/24, Display.height/24);

    /*
     * Manifold persists rather than being a local variable so we're
     * not creating a new object every frame.
     */
    manifold = new ImpulseManifold();

    // end new
  }

  //------------------------------------------------------------------
  public function setBounds(?left:Float = 0,
                            ?top:Float = 0,
                            ?right:Float = 0,
                            ?bottom:Float = 0):Void
  {
    this.left = Math.min(left, right);
    this.right = Math.max(left, right);

    this.top = Math.min(top, bottom);
    this.bottom = Math.max(top, bottom);

    /*
     * There are four separate bodies so different restitution,
     * friction, etc.  could be set for each.
     */

    leftBody = RigidBody2DComponent
      .newBoxBody(BOUNDS_BUFFER, (bottom-top)*2,
                  {
                    x: left-(BOUNDS_BUFFER/2), y: (top+bottom)/2,
                    mass: BOUNDS_MASS,
                    restitution: BOUNDS_RESTITUTION,
                    fixed: true
                  });

    rightBody = RigidBody2DComponent
      .newBoxBody(BOUNDS_BUFFER, (bottom-top)*2,
                  {
                    x: right+(BOUNDS_BUFFER/2), y: (top+bottom)/2,
                    mass: BOUNDS_MASS,
                    restitution: BOUNDS_RESTITUTION,
                    fixed: true
                  });

    topBody = RigidBody2DComponent
      .newBoxBody((right-left)*2, BOUNDS_BUFFER,
                  {
                    x: (left+right)/2, y: top-(BOUNDS_BUFFER/2),
                    mass: BOUNDS_MASS,
                    restitution: BOUNDS_RESTITUTION,
                    fixed: true
                  });

    bottomBody = RigidBody2DComponent
      .newBoxBody((right-left)*2, BOUNDS_BUFFER,
                  {
                    x: (left+right)/2, y: bottom+(BOUNDS_BUFFER/2),
                    mass: BOUNDS_MASS,
                    restitution: BOUNDS_RESTITUTION,
                    fixed: true
                  });

    // end setBounds
  }

  //------------------------------------------------------------------
  public override function update(millis:Int):Void
  {
    for (i in 0...iterations)
      scan();
    // end update
  }


  //--------------------------------------------------------------------
  private function scan():Void
  {

    var hit:Int;
    var body:RigidBody2DComponent;

    var curr = group.head;
    while (curr != null) {
      body = curr.item.body;

      hit = 0;

      manifold.b = body;

      if (body.left() < left && body.xvel < 0) {
        hit = hit | Bounds2DComponent.BOUNDS_LEFT;

        manifold.penetration = left-body.left();
        manifold.normX = 1;
        manifold.normY = 0;
        manifold.a = leftBody;

        manifold.apply();

      } else if (body.right() > right && body.xvel > 0) {
        hit = hit | Bounds2DComponent.BOUNDS_RIGHT;

        manifold.penetration = body.right()-right;
        manifold.normX = -1;
        manifold.normY = 0;
        manifold.a = rightBody;

        manifold.apply();

      }

      if (body.top() < top && body.yvel < 0) {
        hit = hit | Bounds2DComponent.BOUNDS_TOP;

        manifold.penetration = top-body.top();
        manifold.normX = 0;
        manifold.normY = 1;
        manifold.a = topBody;

        manifold.apply();

      } else if (body.bottom() > bottom && body.yvel > 0) {
        hit = hit | Bounds2DComponent.BOUNDS_BOTTOM;

        manifold.penetration = body.bottom() - bottom;
        manifold.normX = 0;
        manifold.normY = -1;
        manifold.a = bottomBody;

        manifold.apply();

      }

      // Notify the object

      curr = curr.next;
    }

    // end scan
  }

  // end ImpulseBoundsCollider
}
