package;

import com.rocketshipgames.haxe.ui.Screen;
import com.rocketshipgames.haxe.device.Display;

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
    var bitmap = new Bitmap (Assets.getBitmapData ("assets/sprites.png"));
    addChild(bitmap);
                
    bitmap.x = (Display.width - bitmap.width) / 2;
    bitmap.y = (Display.height - bitmap.height) / 2;
    // end new
  }

  // end Menu
}
