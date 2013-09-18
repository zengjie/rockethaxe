package com.rocketshipgames.haxe;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.world.World;

import com.rocketshipgames.haxe.gfx.GraphicsContainer;
import com.rocketshipgames.haxe.gfx.Viewport;


class GameScreen
  extends com.rocketshipgames.haxe.ui.Screen
{

  //------------------------------------------------------------
  public var world(default, null):World;

  public var viewport(default, null):Viewport;

  //------------------------------------------------------------
  private var graphicsContainers:List<GraphicsContainer>;


  //------------------------------------------------------------
  public function new(?world:World):Void
  {
    super();

    if (world == null)
      world = new World();
    this.world = world;


    viewport = new Viewport();

    graphicsContainers = new List();

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addGraphicsContainer(gc:GraphicsContainer):Void
  {
    graphicsContainers.add(gc);
    // end addGraphicsContainer
  }


  //------------------------------------------------------------
  private function render():Void
  {
    graphics.clear();
    for (gc in graphicsContainers) {
      gc.render(graphics, viewport);
    }
    // end render
  }

  // end ArcadeScreen
}
