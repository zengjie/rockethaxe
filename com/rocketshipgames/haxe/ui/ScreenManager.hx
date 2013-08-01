package com.rocketshipgames.haxe.ui;

import flash.display.Sprite;


class ScreenManager {

  //------------------------------------------------------------
  private static var placeholder:Sprite;

  private static var panelManager:PanelManager;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public static function initialize():Void
  {
    panelManager = new PanelManager();

    placeholder = new Sprite();
    flash.Lib.current.addChild(placeholder);

    // end initialize
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public static function add(id:String, panel:Panel):Panel
  {
    return panelManager.add(id, panel);
    // end add
  }

  public static function remove(id:String):Void
  {
    panelManager.remove(id);
    // end remove
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public static function show(id:String, ?opts:Dynamic):Void
  {
    if (opts == null)
      opts = {};

    opts.__placeholder = placeholder;

    panelManager.show(id, opts);
    // end show
  }

  //----------------------------------------------------
  public static function hide(id:String, ?opts:Dynamic):Void
  {
    panelManager.hide(id, opts);
    // end hide
  }

  // end ScreenManager
}
