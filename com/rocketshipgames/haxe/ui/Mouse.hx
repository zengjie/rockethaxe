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

import nme.display.DisplayObjectContainer;

import com.eclecticdesignstudio.motion.Actuate;


private enum MouseMode {
  NATIVE;
  CUSTOM;
}

class Mouse {

  public static inline var DEFAULT_IDLE_TIMEOUT:Int = 5000;

  public static var cursor:Bitmap = new Bitmap();

  //------------------------------------------------------------
  private static var mode:MouseMode = NATIVE;
  private static var visible:Bool = true;

  private static var installed:Bool = false;

  private static var idleInstalled:Bool = false;
  private static var idleTimeout:Int;
  private static var idleTimeoutInterval:Int;
  private static var prevIdleTimestamp:Int;
  private static var idled:Bool = false;

  private static var container:DisplayObjectContainer = nme.Lib.current.stage;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function setCursor(bitmapData:BitmapData,
                                   ?c:DisplayObjectContainer):Void
  {
    if (mode == NATIVE && visible) {
      nme.ui.Mouse.hide();
    }

    mode = CUSTOM;

    cursor.bitmapData = bitmapData;

    if (installed)
      return;

    var stage = nme.Lib.current.stage;
    stage.addEventListener(MouseEvent.MOUSE_MOVE, update);
    stage.addEventListener(MouseEvent.ROLL_OVER, show);
    stage.addEventListener(MouseEvent.ROLL_OUT, hide);

    cursor.x = stage.mouseX;
    cursor.y = stage.mouseY;

    if (c != null)
      container = c;

    container.addChild(cursor);
    installed = true;

    // end setCursor
  }

  //------------------------------------------------------------
  public static function disableCursor():Void
  {
    if (!installed)
      return;

    nme.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, update);
    /*
    stage.removeEventListener(MouseEvent.ROLL_OVER, show);
    stage.removeEventListener(Event.MOUSE_LEAVE, hide);
    */

    container.removeChild(cursor);
    installed = false;
    // end disableCursor
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function enableIdleHide(timeout:Int = DEFAULT_IDLE_TIMEOUT):Void
  {
    if (idleInstalled)
      return;

    idleTimeout = idleTimeoutInterval = timeout;
    prevIdleTimestamp = nme.Lib.getTimer();
    nme.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameIdle);
    nme.Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, notIdle);
    nme.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, notIdle);

    idleInstalled = true;
    // end enableIdleHide
  }
  public static function disableIdleHide():Void
  {
    if (!idleInstalled)
      return;

    nme.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameIdle);
    nme.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, notIdle);
    nme.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, notIdle);

    if (visible)
      show();

    idled = false;
    idleInstalled = false;
    // end disableIdleHide
  }

  //------------------------------------------------------------
  private static function onEnterFrameIdle(e:Event=null):Void
  {
    var currTime:Int = nme.Lib.getTimer();
    idleTimeout -= currTime - prevIdleTimestamp;
    prevIdleTimestamp = currTime;

    if (!idled && idleTimeout <= 0) {
      idled = true;
      Actuate.tween(cursor, 0.5, {alpha: 0});
    }
    // end onEnterFrameIdle
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function hide(e:Event = null):Void
  {
    _hide();
    visible = false;
    // end hide
  }

  private static function _hide():Void
  {
    switch (mode) {
    case NATIVE:
      nme.ui.Mouse.hide();

    case CUSTOM:
      cursor.visible = false;
    }
    // end _hide
  }

  public static function show(e:Event = null):Void
  {
    switch (mode) {
    case NATIVE:
      nme.ui.Mouse.show();

    case CUSTOM:
      if (idled) {
        Actuate.stop(cursor, {alpha: null}, false, false);
        idled = false;
      }
      cursor.alpha = 1;
      cursor.visible = true;
    }

    visible = true;
    // end show
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private static function update(e:MouseEvent):Void
  {
    cursor.x = e.stageX;
    cursor.y = e.stageY;

    idleTimeout = idleTimeoutInterval;
    if (idleInstalled && visible) {
      show();
    }

    e.updateAfterEvent();
    // end updateMouse
  }

  private static function notIdle(e:MouseEvent):Void
  {
    idleTimeout = idleTimeoutInterval;
    if (visible)
      show();
    // end down
  }

  // end Mouse
}
