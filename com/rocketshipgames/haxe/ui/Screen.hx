package com.rocketshipgames.haxe.ui;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.ui.Panel;

import flash.display.Sprite;


class Screen
  extends Sprite
  implements Panel
{
  private var id:String;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function added(manager:PanelManager, id:String):Void
  {
    this.id = id;
    #if verbose
      Debug.debug("Added screen " + id);
    #end
  }

  //----------------------------------------------------
  public function removed():Void
  {
    #if verbose
      Debug.debug("Removed screen " + id);
    #end
  }

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    #if verbose
      Debug.debug("Show screen " + id);
    #end

    if (opts != null) {
      var place:Sprite;

      if ((place = opts.__placeholder) != null)
        place.addChild(this);
    }

    // end show
  }

  //----------------------------------------------------
  public function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    #if verbose
      Debug.debug("Hide screen " + id);
    #end

    if (parent != null)
      parent.removeChild(this);
    onComplete();
  }

  // end Screen
}
