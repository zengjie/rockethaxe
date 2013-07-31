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

import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;

import com.eclecticdesignstudio.motion.Actuate;

class DisplayListManager {
  //------------------------------------------------------------
  private var parent:DisplayObjectContainer;
  private var items:List<DisplayListItem>;

  private var shows:List<Void->Void>;
  private var hides:List<Void->Void>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(parent:DisplayObjectContainer):Void
  {
    this.parent = parent;
    items = new List();
    shows = new List();
    hides = new List();
    // end new
  }

  //------------------------------------------------------------
  public function addHelpers(show:Void->Void = null,
                             hide:Void->Void = null):Void
  {
    if (show != null)
      shows.add(show);

    if (hide != null)
      hides.add(hide);
    // end addOVerall
  }

  public function addObject(object:DisplayObject,
                            show:Void->Bool = null,
                            hide:Void->Bool = null):Void
  {
    items.add(new DisplayListItem(object, show, hide));
    // end addObject
  }

  //--------------------------------------------------------------------
  public function show():Void
  {
    for (i in items) {
      if (i.show == null || i.show()) {
        Actuate.stop(i.object, {alpha: null}, false, false);
        i.object.alpha = 0;
        if (!parent.contains(i.object))
          parent.addChild(i.object);
        Actuate.tween(i.object, 1, {alpha: 1});
      }
      // end looping items
    }

    for (i in shows)
      i();
    // end show
  }

  public function hide():Void
  {
    for (i in items) {
      if (i.hide == null || i.hide()) {
        Actuate.stop(i.object, {alpha: null}, false, false);
        Actuate.tween(i.object, 1, {alpha: 0})
          .onComplete(function() {
              if (parent.contains(i.object))
                parent.removeChild(i.object);
            });
      }

      // end looping items
    }

    for (i in hides)
      i();
    // end hide
  }

  // end DisplayListManager
}

//----------------------------------------------------------------------
//----------------------------------------------------------------------
private class DisplayListItem {
  public var object:DisplayObject;
  public var show:Void->Bool;
  public var hide:Void->Bool;

  public function new(object:DisplayObject,
                      show:Void->Bool = null,
                      hide:Void->Bool = null):Void
  {
    this.object = object;
    this.show = show;
    this.hide = hide;
  }
}
