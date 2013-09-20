package com.rocketshipgames.haxe.physics.impulse;

import com.rocketshipgames.haxe.physics.core2d.RigidBody2DComponent;

import com.rocketshipgames.haxe.world.tilemap.TileChunk;
import com.rocketshipgames.haxe.world.tilemap.Tile;


class ImpulseTileChunkCollider
  extends ImpulseCollider
{

  //------------------------------------------------------------

  //--------------------------------------------------------------------
  private var chunk:TileChunk;

  private var manifold:ImpulseManifold;
  private var tileBody:RigidBody2DComponent;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new(chunk:TileChunk):Void
  {
    super();

    this.chunk = chunk;

    /*
     * Body and manifold persist rather than being a local variable so
     * we're not creating a new object every frame.
     */
    tileBody = RigidBody2DComponent.newBoxBody(chunk.catalog.width,
                                               chunk.catalog.height,
                                               { fixed: true, mass:1000 });

    manifold = new ImpulseManifold();
    manifold.a = tileBody;

    // end new
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
    var body:RigidBody2DComponent;
    var left, right, top, bottom:Int;
    var tile:Tile;

    var curr = group.head;
    while (curr != null) {
      body = curr.item.body;

      manifold.b = body;

      left = Math.floor
        (Math.max((body.left()-chunk.left())/chunk.catalog.width, 0));
      top = Math.floor
        (Math.max((body.top()-chunk.top())/chunk.catalog.height, 0));

      right = Math.floor
        (Math.min((body.right()-chunk.left())/chunk.catalog.width,
                  chunk.columns-1));
      bottom = Math.floor
        (Math.min((body.bottom()-chunk.top())/chunk.catalog.height,
                  chunk.rows-1));

      /*
      trace("Left, top " + left + "," + top +
            " -- right, bottom " + right + "," + bottom);
      */

      var r = top;
      while (r <= bottom) {

        var c = left;
        while (c <= right) {

          tile = chunk.tile(c, r);

          if ((tile.collidesAs & body.collidesWith) != 0) {

            tileBody.x = chunk.left() +
              (c*chunk.catalog.width) +
              (chunk.catalog.width/2);

            tileBody.y = chunk.top() +
              (r*chunk.catalog.height) +
              (chunk.catalog.height/2);

            /*
            trace("Collision c,r " + c + "," + r +
                  " x,y " + tileBody.x + "," + tileBody.y);
            */

            if (tileBody.checkCollision(body, manifold)) {
              manifold.apply();
            }

            // End could be a collision
          }

          c++;
        }

        r++;
      }

      // Notify the object based on a single hit flag if collided

      curr = curr.next;
    }

    // end scan
  }

  // end ImpulseTileChunkCollider
}
