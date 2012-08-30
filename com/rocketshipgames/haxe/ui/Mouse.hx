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

import nme.Assets;

import nme.events.Event;
import nme.events.MouseEvent;

import nme.display.Bitmap;
import nme.display.BitmapData;

import com.eclecticdesignstudio.motion.Actuate;


class Mouse {

  public static var CURSOR_POINTER:BitmapData;

  public static var CURSOR_MINIPOINTER:BitmapData;

  public static var CURSOR_HAND:BitmapData;
  public static inline var CURSOR_HAND_X:Float = -6;
  public static inline var CURSOR_HAND_Y:Float = 0;


  public static inline var DEFAULT_IDLE_TIMEOUT:Int = 5000;

  public var cursor(default, null):Bitmap;

  //------------------------------------------------------------
  private static var instance:Mouse = new Mouse();

  private var offscreen:Bool;
  private var idle:Bool;
  private var visibleRequested:Bool;

  private var installed:Bool;

  private var offX:Float;
  private var offY:Float;

  private var idleEnabled:Bool;
  private var idleTimeout:Int;
  private var idleClock:Int;
  private var idleTimestamp:Int;

  private var fading:Bool;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function new():Void
  {

    CURSOR_POINTER = CURSOR_MINIPOINTER = CURSOR_HAND = null;

    offscreen = true;
    idle = true;
    visibleRequested = false;

    cursor = new Bitmap();
    cursor.visible = false;

    offX = 0;
    offY = 0;

    idleEnabled = true;
    idleTimeout = DEFAULT_IDLE_TIMEOUT;
    idleClock = idleTimeout;

    fading = false;

    installed = false;

    // end new
  }

  public static function i():Mouse { return instance; }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function enable(?cursor:BitmapData,
                         ?offX:Float, ?offY:Float):Void
  {
    nme.ui.Mouse.hide();

    CURSOR_POINTER = Assets.getBitmapData("assets/ui/cursor-pointer.png");
    CURSOR_MINIPOINTER=Assets.getBitmapData("assets/ui/cursor-minipointer.png");
    CURSOR_HAND = Assets.getBitmapData("assets/ui/cursor-hand.png");

    if (installed)
      return;

    nme.Lib.current.stage.addEventListener(Event.ENTER_FRAME,
                                           onEnterFrame);
    nme.Lib.current.stage.addEventListener(Event.MOUSE_LEAVE,
                                           mouseLeave);
    nme.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE,
                                           mouseMove);

    nme.Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN,
                                           notIdle);
    nme.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP,
                                           notIdle);
    nme.Lib.current.stage.addEventListener(MouseEvent.ROLL_OVER,
                                           notIdle);

    setCursor(cursor, offX, offY);

    idleTimestamp = nme.Lib.getTimer();

    nme.Lib.current.stage.addChild(this.cursor);
    installed = true;

    show();

    // end enable
  }

  //------------------------------------------------------------
  public function disable():Void
  {
    if (!installed)
      return;

    nme.Lib.current.stage.removeEventListener(Event.ENTER_FRAME,
                                              onEnterFrame);
    nme.Lib.current.stage.removeEventListener(Event.MOUSE_LEAVE,
                                              mouseLeave);
    nme.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE,
                                              mouseMove);

    nme.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN,
                                              notIdle);
    nme.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP,
                                              notIdle);
    nme.Lib.current.stage.removeEventListener(MouseEvent.ROLL_OVER,
                                              notIdle);

    nme.Lib.current.stage.removeChild(cursor);
    installed = false;
    // end enable
  }

  //------------------------------------------------------------
  public function setCursor(cursor:BitmapData = null,
                            offX:Float = 0, offY:Float=0):Void
  {
    if (cursor == null)
      this.cursor.bitmapData = CURSOR_POINTER;
    else
      this.cursor.bitmapData = cursor;

    this.cursor.x -= this.offX;
    this.cursor.y -= this.offY;

    this.offX = offX;
    this.offY = offY;

    this.cursor.x += this.offX;
    this.cursor.y += this.offY;

    // end setCursor
  }

  public function setCursorHand():Void
  {
    setCursor(CURSOR_HAND, CURSOR_HAND_X, CURSOR_HAND_Y);
    // end setCursorHand
  }

  public function setCursorPointer():Void
  {
    setCursor(CURSOR_POINTER, 0, 0);
    // end setCursorDefault
  }

  public function setCursorMiniPointer():Void
  {
    setCursor(CURSOR_MINIPOINTER, 0, 0);
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
    nme.Lib.current.stage.removeChild(cursor);
    visibleRequested = false;
    updateVisibility();
    // end show
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private inline function updateVisibility():Void
  {
    cursor.visible = visibleRequested && !(offscreen || idle);
    if (cursor.visible) {
      if (fading) {
        Actuate.stop(cursor, {alpha: null}, false, false);
        fading = false;
      }
      cursor.alpha = 1;
    }
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
      fading = true;
      Actuate.tween(cursor, 4, {alpha: 0});
    }
    // end onEnterFrameIdle
  }

  //------------------------------------------------------------
  private function mouseLeave(e:Event):Void
  {
    offscreen = true;
    updateVisibility();

    // e.updateAfterEvent();
    // end mouseLeave
  }

  //------------------------------------------------------------
  private function mouseMove(e:MouseEvent):Void
  {
    cursor.x = e.stageX + offX;
    cursor.y = e.stageY + offY;

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
