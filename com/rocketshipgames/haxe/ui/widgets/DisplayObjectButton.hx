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

package com.rocketshipgames.haxe.ui.widgets;

import nme.display.DisplayObjectContainer;

import nme.display.DisplayObject;

import com.rocketshipgames.haxe.ui.widgets.Button;


class DisplayObjectButton
  extends Button
{

  private var upDisplayObject:DisplayObject;
  private var overDisplayObject:DisplayObject;
  private var downDisplayObject:DisplayObject;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(action:Void->Void,
                      upDisplayObject:DisplayObject,
                      overDisplayObject:DisplayObject = null,
                      downDisplayObject:DisplayObject = null,
                      container:DisplayObjectContainer):Void
  {
    super(action, container);

    this.upDisplayObject = upDisplayObject;
    this.overDisplayObject = overDisplayObject;
    this.downDisplayObject = downDisplayObject;

    if (downDisplayObject != null) {
      downDisplayObject.visible = false;
      addChild(downDisplayObject);
    }

    if (overDisplayObject != null) {
      overDisplayObject.visible = false;
      addChild(overDisplayObject);
    }

    addChild(upDisplayObject);

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private override function updateGraphicState():Void
  {

    switch (state) {

    case UP:
      upDisplayObject.visible = true;
      if (overDisplayObject != null)
        overDisplayObject.visible = false;
      if (downDisplayObject != null)
        downDisplayObject.visible = false;


    case OVER:
      if (overDisplayObject != null) {
        upDisplayObject.visible = false;
        overDisplayObject.visible = true;
      } else
        upDisplayObject.visible = true;

      if (downDisplayObject != null)
        downDisplayObject.visible = false;


    case DOWN:
      if (overDisplayObject != null)
        overDisplayObject.visible = false;

      if (downDisplayObject != null) {
        downDisplayObject.visible = true;
        upDisplayObject.visible = false;
      } else {
        upDisplayObject.visible = true;
      }

    case DISABLED:
      upDisplayObject.visible = true;
      if (overDisplayObject != null)
        overDisplayObject.visible = false;
      if (downDisplayObject != null)
        downDisplayObject.visible = false;
    }

    // end updateGraphicState
  }

  // end DisplayObjectButton
}
