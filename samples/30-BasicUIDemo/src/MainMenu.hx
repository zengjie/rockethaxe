package;

import openfl.Assets;

import flash.events.KeyboardEvent;

import flash.text.TextFormatAlign;

import motion.Actuate;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.ui.Screen;
import com.rocketshipgames.haxe.ui.ScreenManager;
import com.rocketshipgames.haxe.ui.Panel;
import com.rocketshipgames.haxe.ui.PanelManager;

import com.rocketshipgames.haxe.gfx.text.TextBitmap;
import com.rocketshipgames.haxe.ui.widgets.TextBitmapButton;
import com.rocketshipgames.haxe.ui.widgets.LinearWidgetList;

import com.rocketshipgames.haxe.gfx.flags.Orientation;
import com.rocketshipgames.haxe.gfx.flags.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.flags.VerticalAlignment;
import com.rocketshipgames.haxe.gfx.flags.GrowthDirection;

import com.rocketshipgames.haxe.device.Mouse;


class MainMenu
  extends Screen
{

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    super();

    var uiList:LinearWidgetList;

    var style:Dynamic =
      { borderWidth: 2,
        padding: 2,
        justification: TextFormatAlign.LEFT,
      };
    var upColors:Dynamic = { bgcolor: 0xffffffff, color: 0x000000 };
    var overColors:Dynamic = { bgcolor: 0xff000000, color: 0xffffff };
    var downColors:Dynamic = { bgcolor: 0xff000000, color: 0x333333 };

    uiList = new LinearWidgetList
      (Display.width/2, Display.height/2, this,
       { orientation: VERTICAL,
         horizontalAlignment: HorizontalAlignment.CENTER,
         verticalAlignment: VerticalAlignment.MIDDLE,
         horizontalJustification: HorizontalAlignment.CENTER,
       });

    //-- Place a bunch of buttons into the list
    TextBitmapButton.populateList
      (uiList,
       [ {action: gotoGame, text: "Play Game"},
         {action: doSettings, text: "Settings"},
         {action: doAbout, text: "About"},
         {action: doHelp, text: "Help!"} ],
       style, upColors, overColors, downColors);


    //-- Manually construct another list and place at bottom of list
    var uiList2:LinearWidgetList;
    uiList2 = new LinearWidgetList
      (0, 0,
       { orientation: HORIZONTAL,
         horizontalAlignment: HorizontalAlignment.LEFT,
         verticalAlignment: VerticalAlignment.TOP});

    Reflect.deleteField(style, "borderBottomWidth");
    uiList2.add(new TextBitmapButton
               (null, "Sponsor",
                style, upColors, overColors, downColors));
    uiList2.add(new TextBitmapButton
               (function() {
                 flash.Lib.getURL
                   (new flash.net.URLRequest("http://rocketshipgames.com"));
                },
                "rocketshipgames.com",
                style, upColors, overColors, downColors));
    uiList2.add(new TextBitmapButton
               (null, "Sponsor",
                style, upColors, overColors, downColors));
    uiList.add(uiList2);

    uiList.show();

    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public override function show(?opts:Dynamic):Void
  {
    trace("Showing main menu.");

    flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

    Mouse.enable();

    super.show(opts);

    // end button
  }

  public override function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    trace("Hiding main menu");

    Mouse.disable();

    flash.Lib.current.stage.removeEventListener
      (KeyboardEvent.KEY_DOWN, onKeyDown);

    Actuate.tween(this, 1, {alpha: 0})
      .onComplete(function() {
          hideComplete(onComplete, opts);
        });

    // end hide
  }

  private function hideComplete(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    super.hide(onComplete, opts);
    // end hideComplete
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function onKeyDown(e:KeyboardEvent):Void
  {
    gotoGame();
  }

  private function gotoGame():Void
  {
    ScreenManager.show("game");
    // end gotoGame
  }

  private function doSettings():Void
  {
    trace("SETTINGS!");
    Mouse.setCursorHand();
    // end doSettings
  }

  private function doAbout():Void
  {
    trace("ABOUT!");
    Mouse.setCursorMiniPointer();
    // end doAbout
  }

  private function doHelp():Void
  {
    trace("HELP!");
    Mouse.setCursor();
    // end doAbout
  }

  // end MainMenu
}
