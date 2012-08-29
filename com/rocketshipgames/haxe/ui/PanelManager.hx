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

class PanelManager {

  //------------------------------------------------------------
  private var panels:Hash<Panel>;
  private var current:Panel;
  private var next:Panel;
  private var nextOpts:Dynamic;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    panels = new Hash();
    current = null;
    next = null;
    nextOpts = null;
    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function add(id:String, panel:Panel):Panel
  {
    if (panels.get(id) != null) {
      trace("Panel " + id + " already exists!");
      return null;
    }

    panels.set(id, panel);
    panel.added(this, id);
    return panel;
    // end register
  }

  public function remove(id:String):Void
  {
    var panel:Panel;
    if ((panel = panels.get(id)) == null) {
      trace("Unknown panel " + id);
      return;
    }

    panels.remove(id);
    panel.removed();
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(id:String, ?opts:Dynamic):Void
  {
    var panel:Panel;
    if ((panel = panels.get(id)) == null) {
      trace("Unknown panel " + id);
      return;
    }

    if (current == null) {
      current = panel;
      panel.show(opts);
      return;
    }

    if (panel == current) {
      trace("Panel " + id + " is already showing.");
      return;
    }

    if (current.hide(this, opts)) {
      current = panel;
      panel.show(opts);
    } else {
      next = panel;
      nextOpts = opts;
    }

    // end show
  }

  //------------------------------------------------------------
  public function hide(id:String, ?opts:Dynamic):Void
  {
    var panel:Panel;
    if ((panel = panels.get(id)) == null) {
      trace("Unknown panel " + id);
      return;
    }

    if (panel != current) {
      trace("Panel " + id + "is not currently showing.");
      return;
    }

    if (panel.hide(this, opts))
      current = null;
    // end hide
  }

  public function hideComplete(panel:Panel):Void
  {
    if (current == null) {
      trace("No panel is currently showing.");
    }

    if (panel != current) {
      trace("Panel reporting hide complete is not currently showing.");
    }

    if (next != null) {
      current = next;
      next.show(nextOpts);
    } else
      current = null;

    // end hideComplete
  }

  /*
   * Does it need a switch()?
   * - Is it necessary for panels to completely transition out before
   *   transitioning in a newone ?
   */

  // end PanelManager
}


/*
private class PanelHandle
{
  public id:String;
  public panel:Panel;
  public visible:Bool;

  public function new(id:String, panel:Panel):Void
  {
    this.id = id;
    this.panel = panel;
    visible = false;
    // end new
  }

  public function show(?opts:Dynamic):Void
  {
    panel.show(opts);
    // end show
  }

  // end PanelHandle
}
*/
