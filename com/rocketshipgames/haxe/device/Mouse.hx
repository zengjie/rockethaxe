package com.rocketshipgames.haxe.device;

import flash.events.Event;
import flash.events.MouseEvent;


interface MouseAppearanceWrapper {

  public function enable(?cursor:String, ?hotspotX:Float, ?hotspotY:Float):Void;
  public function disable():Void;

  public function updateVisibility(visibility:Bool):Void;
  public function updatePosition(x:Float, y:Float):Void;
  public function idleOut():Void;

  function setCursor(?asset:String, ?hotspotX:Float, ?hotspotY:Float):Void;

  // end MouseAppearanceWrapper
}


class Mouse {

  public static var CURSOR_POINTER:String
    = "assets/ui/cursor-pointer.png";
  public static var CURSOR_MINIPOINTER:String
    = "assets/ui/cursor-minipointer.png";
  public static var CURSOR_HAND:String
    = "assets/ui/cursor-hand.png";

  public static inline var CURSOR_HAND_X:Float = 6;
  public static inline var CURSOR_HAND_Y:Float = 0;

  public static inline var DEFAULT_IDLE_TIMEOUT:Int = 5000;


  //------------------------------------------------------------
  private static var offscreen:Bool = false;
  private static var idle:Bool = true;
  private static var visibleRequested:Bool = false;
  private static var previousVisibility:Bool = false;

  private static var installed:Bool = false;

  private static var idleEnabled:Bool = true;
  private static var idleTimeout:Int = DEFAULT_IDLE_TIMEOUT;
  private static var idleClock:Int = DEFAULT_IDLE_TIMEOUT;
  private static var idleTimestamp:Int;

  private static var visibilityListeners:List<Bool->Void> = new List();

  #if flash
    private static var appearance:MouseAppearanceWrapper =
      new com.rocketshipgames.haxe.device.platforms.FlashMouseAppearance();
  #else
    private static var appearance:MouseAppearanceWrapper =
      new com.rocketshipgames.haxe.device.platforms.DefaultMouseAppearance();
  #end


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function enable(?cursor:String,
                                ?hotspotX:Float, ?hotspotY:Float):Void
  {
    flash.ui.Mouse.hide();

    #if android
      return;
    #end

    if (installed) {
      if (cursor != null)
        appearance.setCursor(cursor, hotspotX, hotspotY);
      show();
      return;
    }

    var stage = flash.Lib.current.stage;
    stage.addEventListener(Event.ENTER_FRAME,           onEnterFrame);

    stage.addEventListener(Event.MOUSE_LEAVE,           mouseLeave);

    // Thought this might be sent in cpp target to capture leaving the
    // stage, but it does not seem to
    //stage.addEventListener(MouseEvent.ROLL_OUT,         mouseLeave);

    stage.addEventListener(MouseEvent.MOUSE_MOVE,       mouseMove);

    stage.addEventListener(MouseEvent.MOUSE_DOWN,       notIdle);
    stage.addEventListener(MouseEvent.MOUSE_UP,         notIdle);
    stage.addEventListener(MouseEvent.ROLL_OVER,        notIdle);

    appearance.enable(cursor, hotspotX, hotspotY);

    installed = true;
    idleTimestamp = flash.Lib.getTimer();

    show();

    // end enable
  }

  //------------------------------------------------------------
  public static function disable():Void
  {
    appearance.disable();

    if (!installed) {
      return;
    }

    var stage = flash.Lib.current.stage;
    stage.removeEventListener(Event.ENTER_FRAME,        onEnterFrame);

    stage.removeEventListener(Event.MOUSE_LEAVE,        mouseLeave);

    // Thought this might be sent in cpp target to capture leaving the
    // stage, but it does not seem to
    //stage.removeEventListener(MouseEvent.ROLL_OUT,    mouseLeave);

    stage.removeEventListener(MouseEvent.MOUSE_MOVE,    mouseMove);

    stage.removeEventListener(MouseEvent.MOUSE_DOWN,    notIdle);
    stage.removeEventListener(MouseEvent.MOUSE_UP,      notIdle);
    stage.removeEventListener(MouseEvent.ROLL_OVER,     notIdle);

    installed = false;
    // end enable
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function addVisibilityListener(fn:Bool->Void):Void
  {
    visibilityListeners.add(fn);
    // end addVisibilityListener
  }

  public static function removeVisibilityListener(fn:Bool->Void):Void
  {
    visibilityListeners.remove(fn);
    // end removeVisibilityListener
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function setCursor(?asset:String,
                                   ?hotspotX:Float, ?hotspotY:Float):Void
  {
    appearance.setCursor(asset, hotspotX, hotspotY);
    // end setCursor
  }

  public static function setCursorHand():Void
  {
    appearance.setCursor(CURSOR_HAND, CURSOR_HAND_X, CURSOR_HAND_Y);
    // end setCursorHand
  }

  public static function setCursorPointer():Void
  {
    appearance.setCursor(CURSOR_POINTER, 0, 0);
    // end setCursorDefault
  }

  public static function setCursorMiniPointer():Void
  {
    appearance.setCursor(CURSOR_MINIPOINTER, 0, 0);
    // end setCursorDefault
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function setIdleTimeout(timeout:Int = 0):Void {
    idleEnabled = true;

    if (timeout == 0)
      idleTimeout = DEFAULT_IDLE_TIMEOUT;
    else
      idleTimeout = timeout;

    idleClock = idleTimeout;
    idleTimestamp = flash.Lib.getTimer();
    // end enableIdle
  }

  public static function disableIdle():Void
  {
    idleEnabled = false;
    updateVisibility();
    // end disableIdle
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function show(e:Event = null):Void
  {
    visibleRequested = true;
    resetIdle();
    updateVisibility();
    // end show
  }

  public static function hide(e:Event = null):Void
  {
    visibleRequested = false;
    updateVisibility();
    // end show
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static inline function isVisible():Bool
  {
    return (visibleRequested && !(offscreen || idle));
    // end isVisible
  }

  private static inline function updateVisibility(propagate:Bool=true):Void
  {
    var v:Bool = isVisible();
    if (previousVisibility != v) {
      for (f in visibilityListeners)
        f(v);
      previousVisibility = v;
      if (propagate)
        appearance.updateVisibility(v);
    }
    // end updateVisibility
  }

  private static function resetIdle():Void
  {
    idleClock = idleTimeout;
    idle = false;
    // end resetIdle
  }

  public static function goIdle():Void
  {
    if (!idleEnabled)
      return;
    idle = true;
    updateVisibility(false);
    appearance.idleOut();
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private static function onEnterFrame(e:Event=null):Void
  {
    var currTime:Int = flash.Lib.getTimer();
    idleClock -= currTime - idleTimestamp;
    idleTimestamp = currTime;

    if (!idle && idleClock <= 0) {
      goIdle();
    }
    // end onEnterFrameIdle
  }

  //------------------------------------------------------------
  private static function mouseLeave(e:Event):Void
  {
    if (!offscreen) {
      offscreen = true;
      updateVisibility();
    }
    // e.updateAfterEvent();
    // end mouseLeave
  }

  //------------------------------------------------------------
  private static function mouseMove(e:MouseEvent):Void
  {
    appearance.updatePosition(e.stageX, e.stageY);

    offscreen = false;
    resetIdle();
    updateVisibility();

    //e.updateAfterEvent();
    // end updateMouse
  }

  //------------------------------------------------------------
  private static function notIdle(e:MouseEvent):Void
  {
    offscreen = false;
    resetIdle();
    updateVisibility();
    // e.updateAfterEvent();
    // end rollOver
  }

  // end Mouse
}
