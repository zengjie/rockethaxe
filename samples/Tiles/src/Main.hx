package;

import openfl.Assets;

import com.rocketshipgames.haxe.ArcadeScreen;

import com.rocketshipgames.haxe.gfx.sprites.SpritesheetContainer;


class Main
  extends com.rocketshipgames.haxe.Game
{

  private var game:ArcadeScreen;

  private var graphics:SpritesheetContainer;


  //--------------------------------------------------------------------
  public function new():Void
  {
    trace("Tiles Demo");

    //-- The base Game class sets up the display, mouse, audio, etc
    super();

    //-- ArcadeScreen is a Screen which drives a game World (entities,
    //-- mechanics, etc), renders graphics, pauses on unfocus, etc.
    game = new ArcadeScreen();

    graphics = new SpritesheetContainer
      (Assets.getBitmapData("assets/water-tiles.png"));
    game.addGraphicsContainer(graphics);

    //-- Add the game to the display.  In a real game this would be
    //-- done using ScreenManager to transition between menus, etc.
    flash.Lib.current.addChild(game);

    // end new
  }

  // end Main
}
