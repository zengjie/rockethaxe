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

import com.rocketshipgames.haxe.ui.Panel;

class MinimalPanel
  implements Panel
{

  //------------------------------------------------------------
  private var onShow:Dynamic->?Dynamic->Void;
  private var onHide:PanelNotifier->Dynamic->?Dynamic->Void;

  private var userData:Dynamic;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(onShow:Dynamic->?Dynamic->Void,
                      onHide:PanelNotifier->Dynamic->?Dynamic->Void):Void
  {
    this.onShow = onShow;
    this.onHide = onHide;
    userData = {};
    // end new
  }

  public function added(manager:PanelManager, id:String):Void {}
  public function removed():Void {}

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    if (onShow != null)
      onShow(userData, opts);
    // end show
  }

  public function hide(onComplete:PanelNotifier, ?opts:Dynamic):Void
  {
    if (onHide != null)
      onHide(onComplete, userData, opts);
    // end hide
  }

  // end MinimalPanel
}
