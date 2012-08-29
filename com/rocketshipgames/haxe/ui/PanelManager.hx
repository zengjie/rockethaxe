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

import com.rocketshipgames.haxe.debug.Debug;

class PanelManager {

  //------------------------------------------------------------
  private var panels:Hash<PanelHandle>;

  private var current:PanelHandle;

  private var next:PanelHandle;
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
      Debug.error("Panel " + id + " already exists!");
      return null;
    }

    panels.set(id, new PanelHandle(this, id, panel));
    panel.added(this, id);
    return panel;
    // end register
  }

  public function remove(id:String):Void
  {
    var panel:PanelHandle;
    if ((panel = panels.get(id)) == null) {
      Debug.error("Unknown panel " + id);
      return;
    }

    panels.remove(id);
    panel.removed(this);
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(id:String, ?opts:Dynamic):Void
  {
    var panel:PanelHandle;
    if ((panel = panels.get(id)) == null) {
      Debug.error("Unknown panel " + id);
      return;
    }

    if (current == null)
      showComplete(panel, opts);
    else {
      next = panel;
      nextOpts = opts;
      current.hide(opts);
    }
    // end show
  }

  private function showComplete(panel:PanelHandle, ?opts:Dynamic):Void
  {
    current = panel;
    panel.show(opts);
    // end show
  }


  //------------------------------------------------------------
  public function hide(id:String, ?opts:Dynamic):Void
  {
    var panel:PanelHandle;
    if ((panel = panels.get(id)) == null) {
      Debug.error("Unknown panel " + id);
      return;
    }

    panel.hide(opts);
    // end hide
  }

  public function hideComplete(panel:PanelHandle):Void
  {
    // If the client calls onComplete twice, bail
    if (panel != current) {
      Debug.error("Panel " + panel.getID() + "notified hide complete " +
                  "while not current.");
      return;
    }

    current = null;
    if (next != null) {
      showComplete(next, nextOpts);
    }
    // end hideComplete
  }

  // end PanelManager
}


private enum PanelStatus {
  SHOWING;
  HIDING;
  HIDDEN;
}

private class PanelHandle
{

  private var manager:PanelManager;
  private var id:String;
  private var panel:Panel;
  private var status:PanelStatus;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(manager:PanelManager, id:String, panel:Panel):Void
  {
    this.manager = manager;
    this.id = id;
    this.panel = panel;
    status = HIDDEN;
    // end new
  }

  public function removed(manager:PanelManager):Void
  {
    if (status == SHOWING)
      panel.hide(hideComplete);
    // end removed
  }

  public function getID():String { return id; }
  public function getPanel():Panel { return panel; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    if (status != SHOWING) {
      status = SHOWING;
      panel.show(opts);
    } else {
      Debug.error("Panel " + id + " is already showing.");
    }
    // end show
  }

  //------------------------------------------------------------
  public function hide(?opts:Dynamic):Void
  {
    if (status == SHOWING) {
      status = HIDING;
      panel.hide(hideComplete, opts);
    } else {
      Debug.error("Panel " + id + " is not showing.");
    }
    // end hide
  }

  private function hideComplete():Void
  {
    status = HIDDEN;
    manager.hideComplete(this);
  }

  // end PanelHandle
}
