/*
 * Copyright (c) 2012 Joe Kopena <tjkopena@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.rocketshipgames.haxe.ui;

import nme.events.Event;
import nme.events.MouseEvent;


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

  public static var CURSOR_POINTER:String = "assets/ui/cursor-pointer.png";
  public static var CURSOR_MINIPOINTER:String =
    "assets/ui/cursor-minipointer.png";
  public static var CURSOR_HAND:String = "assets/ui/cursor-hand.png";
  public static inline var CURSOR_HAND_X:Float = 6;
  public static inline var CURSOR_HAND_Y:Float = 0;

  public static inline var DEFAULT_IDLE_TIMEOUT:Int = 5000;


  //------------------------------------------------------------
  private static var instance:Mouse = new Mouse();

  private var offscreen:Bool;
  private var idle:Bool;
  private var visibleRequested:Bool;

  private var installed:Bool;

  private var idleEnabled:Bool;
  private var idleTimeout:Int;
  private var idleClock:Int;
  private var idleTimestamp:Int;

  private var appearance:MouseAppearanceWrapper;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function new():Void
  {
    installed = false;

    offscreen = true;
    idle = true;
    visibleRequested = false;

    idleEnabled = true;
    idleTimeout = DEFAULT_IDLE_TIMEOUT;
    idleClock = idleTimeout;

    #if flash
      appearance =
        new com.rocketshipgames.haxe.ui.platforms.FlashMouseAppearance();
    #else
      appearance =
        new com.rocketshipgames.haxe.ui.platforms.DefaultMouseAppearance();
    #end

    // end new
  }

  public static function i():Mouse { return instance; }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function enable(?cursor:String, ?hotspotX:Float, ?hotspotY:Float):Void
  {
    nme.ui.Mouse.hide();

    if (installed)
      return;

    var stage = nme.Lib.current.stage;
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
    idleTimestamp = nme.Lib.getTimer();

    show();

    // end enable
  }

  //------------------------------------------------------------
  public function disable():Void
  {
    if (!installed)
      return;

    appearance.disable();

    var stage = nme.Lib.current.stage;
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

  //------------------------------------------------------------
  public function setCursor(?asset:String, ?hotspotX:Float, ?hotspotY:Float):Void
  {
    appearance.setCursor(asset, hotspotX, hotspotY);
    // end setCursor
  }

  public function setCursorHand():Void
  {
    appearance.setCursor(CURSOR_HAND, CURSOR_HAND_X, CURSOR_HAND_Y);
    // end setCursorHand
  }

  public function setCursorPointer():Void
  {
    appearance.setCursor(CURSOR_POINTER, 0, 0);
    // end setCursorDefault
  }

  public function setCursorMiniPointer():Void
  {
    appearance.setCursor(CURSOR_MINIPOINTER, 0, 0);
    // end setCursorDefault
  }


  //------------------------------------------------------------
  public function setIdleTimeout(timeout:Int = 0):Void {
    idleEnabled = true;

    if (timeout == 0)
      idleTimeout = DEFAULT_IDLE_TIMEOUT;
    else
      idleTimeout = timeout;

    idleClock = idleTimeout;
    idleTimestamp = nme.Lib.getTimer();

    // end enableIdle
  }

  public function disableIdle():Void
  {
    idleEnabled = false;
    // end disableIdle
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(e:Event = null):Void
  {
    visibleRequested = true;
    updateVisibility();
    // end show
  }

  public function hide(e:Event = null):Void
  {
    visibleRequested = false;
    updateVisibility();
    // end show
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public inline function updateVisibility():Void
  {
    appearance.updateVisibility(visibleRequested && !(offscreen || idle));
    // end updateVisibility
  }

  private function resetIdle():Void
  {
    idleClock = idleTimeout;
    idle = false;
    // end resetIdle
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function onEnterFrame(e:Event=null):Void
  {
    var currTime:Int = nme.Lib.getTimer();
    idleClock -= currTime - idleTimestamp;
    idleTimestamp = currTime;

    if (!idle && idleClock <= 0) {
      idle = true;
      appearance.idleOut();
    }
    // end onEnterFrameIdle
  }

  //------------------------------------------------------------
  private function mouseLeave(e:Event):Void
  {
    if (!offscreen) {
      offscreen = true;
      updateVisibility();
    }
    // e.updateAfterEvent();
    // end mouseLeave
  }

  //------------------------------------------------------------
  private function mouseMove(e:MouseEvent):Void
  {
    appearance.updatePosition(e.stageX, e.stageY);

    offscreen = false;
    resetIdle();
    updateVisibility();

    //e.updateAfterEvent();
    // end updateMouse
  }

  //------------------------------------------------------------
  private function notIdle(e:MouseEvent):Void
  {
    offscreen = false;
    resetIdle();
    updateVisibility();
    // e.updateAfterEvent();
    // end rollOver
  }

  // end Mouse
}
