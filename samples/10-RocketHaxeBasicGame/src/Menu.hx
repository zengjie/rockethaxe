package;

import com.rocketshipgames.haxe.ui.Screen;
import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.gfx.text.TextBitmap;

import flash.display.Bitmap;
import openfl.Assets;


class Menu
  extends Screen
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    super();

    // Put the RocketHaxe logo in the bottom right
    var rockethaxe =
      new Bitmap(Assets.getBitmapData("assets/rockethaxe-100x30.png"));
    rockethaxe.x = Display.width - (rockethaxe.width+8);
    rockethaxe.y = Display.height - (rockethaxe.height+8);
    addChild(rockethaxe);

    var title =
      TextBitmap.makeBitmap("RocketHaxe Demo Shooter",
                            { size: 32 });
    title.x = (Display.width - title.width)/2;
    title.y = (Display.height/5) - (title.height/2);
    addChild(title);

    // end new
  }

  // end Menu
}
