package com.rocketshipgames.haxe.device;

import flash.display.StageAlign;
import flash.display.StageScaleMode;

class Display
{

  public static var width(default,null):Float;
  public static var height(default,null):Float;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function configure(align:StageAlign, scale:StageScaleMode):Void
  {
    flash.Lib.current.stage.align = align;
    flash.Lib.current.stage.scaleMode = scale;

    /*
     * This little oddity is to account for the fact that the
     * standalone Flash player starts at some default window size, and
     * then adjust to your requested stage size.  If you poll
     * stageWidth/stageHeight too early, before it does that, you'll
     * get funny values.  However, the loaderInfo width and height are
     * always correct.  Unfortunately, the Android target doesn't have
     * width and height properties on all the objects...
     */

    #if flash
      width = flash.Lib.current.loaderInfo.width;
      height = flash.Lib.current.loaderInfo.height;
    #else
      width = flash.Lib.current.stage.stageWidth;
      height = flash.Lib.current.stage.stageHeight;
    #end

    #if verbose
      haxe.Log.trace("Display width, height: " + width + ", " + height);
    #end
    // end configure
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function configureStandard():Void
  {
    configure(StageAlign.TOP_LEFT, StageScaleMode.NO_SCALE);
    // end StandardConfiguration
  }

  // end Screen
}
