package;

import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.Screen;
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.gfx.text.TextBitmap;
import com.rocketshipgames.haxe.gfx.widgets.DecoratedBitmap;
import com.rocketshipgames.haxe.ui.widgets.TextBitmapButton;

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

    // Put the title up center
    var title =
      TextBitmap.makeBitmap("RocketHaxe Demo Shooter",
                            { size: 32, color: 0xffffff });
    title.x = (Display.width - title.width)/2;
    title.y = (Display.height/5) - (title.height/2);
    addChild(title);


    // Put the RocketHaxe logo in the bottom right
    var rockethaxe = DecoratedBitmap.makeBitmap
      (Assets.getBitmapData("assets/rockethaxe-100x30.png"),
       { padding: 2, bgcolor: 0xffffffff });
    rockethaxe.x = Display.width - (rockethaxe.width+8);
    rockethaxe.y = Display.height - (rockethaxe.height+8);
    addChild(rockethaxe);


    // Put a Play button in the middle
    var play =
      new TextBitmapButton
      (function():Void { ScreenManager.show("game"); },
       "Play",
       { size: 18, color: 0xdf000000, bgcolor: 0xdfffffff,
         padding: 8, paddingLeft: 24, paddingRight: 24,
         borderWidth: 2, borderColor: 0xff000000,
       },
       { },
       { color: 0xff000000, bgcolor: 0xffffffff, borderColor: 0xff000000 },
       { color: 0xffffffff, bgcolor: 0xff000000, borderColor: 0xffffffff }
       );
    play.x = (Display.width - play.width)/2;
    play.y = (Display.height - play.height)/2;
    addChild(play);
    play.show();

    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public override function show(?opts:Dynamic):Void
  {
    com.rocketshipgames.haxe.device.Mouse.enable();
    super.show(opts);
    // end show
  }

  //----------------------------------------------------
  public override function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    com.rocketshipgames.haxe.device.Mouse.disable();
    super.hide(onComplete, opts);
    // end show
  }

  // end Menu
}
