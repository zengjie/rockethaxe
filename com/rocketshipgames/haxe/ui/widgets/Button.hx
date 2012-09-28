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

import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

import com.rocketshipgames.haxe.ui.UIWidget;

enum ButtonState {
  UP;
  OVER;
  DOWN;
  DISABLED;
}

class Button
  extends Sprite,
  implements UIWidget
{

  //------------------------------------------------------------
  public var action:Void->Void;

  public var onMouseOver:Void->Void;
  public var onMouseOut:Void->Void;

  //------------------------------------------------------------
  private var state:ButtonState;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(action:Void->Void,
                      ?container:DisplayObjectContainer):Void
  {
    super();

    this.action = action;

    state = UP;

    addEventListener(MouseEvent.CLICK, click);

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
    addEventListener(MouseEvent.MOUSE_UP, mouseUp);
    addEventListener(MouseEvent.ROLL_OVER, rollOver);
    addEventListener(MouseEvent.ROLL_OUT, rollOut);

    onMouseOver = onMouseOut = null;

    visible = false;
    if (container != null)
      container.addChild(this);

    // end new
  }

  public function setContainer(container:DisplayObjectContainer):Void
  {
    if (parent != null)
      parent.removeChild(this);
    container.addChild(this);
    // end setContainer
  }

  public function remove():Void
  {
    if (parent != null)
      parent.removeChild(this);
    // end remove
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
  private function updateGraphicState():Void {}


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    visible = true;
    // end show
  }

  public function hide(?opts:Dynamic):Void
  {
    visible = false;
    // end hide
  }

  public function disable():Void
  {
    state = DISABLED;
    updateGraphicState();
    // end disable
  }

  public function enable():Void
  {
    state = UP;
    updateGraphicState();
    // end enabled
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
    if (state != DISABLED && state != DOWN) {
      state = DOWN;
      updateGraphicState();
    }
    // end mouseUp
  }

  private function mouseUp(e:Event):Void
  {
    //trace("Up");
    if (state != DISABLED && state != OVER) {
      state = OVER;
      updateGraphicState();
    }
    // end mouseUp
  }

  private function rollOver(e:Event):Void
  {
    //trace("Roll over");
    if (state != DISABLED && state != OVER) {
      state = OVER;
      updateGraphicState();
      if (onMouseOver != null)
        onMouseOver();
    }
    // end rollOver
  }

  private function rollOut(e:Event):Void
  {
    //trace("Roll out");
    if (state != DISABLED && state != UP) {
      state = UP;
      updateGraphicState();
      if (onMouseOut != null)
        onMouseOut();
    }
    // end rollOut
  }

  // end Button
}
