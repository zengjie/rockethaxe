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

/*
 * This class exists, rather than using SimpleButton, for two reasons:
 *   - So I can add hotkeys.
 *   - A bug in SimpleButton such that it clobbers the focus when it
 *     is removed from the stage, and you have to have a hack to put
 *     the focus back somewhere reasonable.
 */

package com.rocketshipgames.haxe.ui.widgets;

import nme.events.Event;
import nme.events.MouseEvent;

import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

import com.rocketshipgames.haxe.ui.UIWidget;

class Button
  extends Sprite,
  implements UIWidget
{
  private var container:DisplayObjectContainer;
  private var action:Void->Void;

  private var upGraphic:DisplayObject;
  private var overGraphic:DisplayObject;
  private var downGraphic:DisplayObject;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObjectContainer,
                      action:Void->Void,
                      upGraphic:DisplayObject,
                      overGraphic:DisplayObject,
                      downGraphic:DisplayObject):Void
  {
    super();

    this.upGraphic = upGraphic;
    this.overGraphic = overGraphic;
    this.downGraphic = downGraphic;

    addChild(upGraphic);
    addChild(overGraphic);
    addChild(downGraphic);

    this.container = container;
    this.action = action;

    addEventListener(MouseEvent.CLICK, click);

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
    addEventListener(MouseEvent.MOUSE_UP, mouseUp);
    addEventListener(MouseEvent.ROLL_OVER, rollOver);
    addEventListener(MouseEvent.ROLL_OUT, rollOut);

    show();

    // end new
  }

  //------------------------------------------------------------
  public function getX():Float { return x; }
  public function getY():Float { return y; }

  public function setX(x:Float):Float { return this.x = x;}
  public function setY(y:Float):Float { return this.y = y;}

  public function getWidth():Float { return width; }
  public function getHeight():Float { return height; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    upGraphic.visible = true;
    overGraphic.visible = false;
    downGraphic.visible = false;
    container.addChild(this);
    // end show
  }

  public function hide(?opts:Dynamic):Void
  {
    container.removeChild(this);
    // end hide
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function click(e:Event):Void
  {
    //trace("Click");
    if (action != null)
      action();
    // end click
  }

  private function mouseDown(e:Event):Void
  {
    //trace("Down");
    upGraphic.visible = false;
    overGraphic.visible = false;
    downGraphic.visible = true;
    // end mouseUp
  }

  private function mouseUp(e:Event):Void
  {
    //trace("Up");
    upGraphic.visible = false;
    overGraphic.visible = true;
    downGraphic.visible = false;
    // end mouseUp
  }

  private function rollOver(e:Event):Void
  {
    //trace("Roll over");
    upGraphic.visible = false;
    overGraphic.visible = true;
    downGraphic.visible = false;
    // end rollOver
  }

  private function rollOut(e:Event):Void
  {
    //trace("Roll out");
    upGraphic.visible = true;
    overGraphic.visible = false;
    downGraphic.visible = false;
    // end rollOut
  }

  // end Button
}
