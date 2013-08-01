package com.rocketshipgames.haxe.ui;

import com.rocketshipgames.haxe.debug.Debug;


class PanelManager {

  //------------------------------------------------------------
  private var panels:Map<String,PanelHandle>;

  private var current:PanelHandle;

  private var next:PanelHandle;
  private var nextOpts:Dynamic;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new():Void
  {
    panels = new Map<String,PanelHandle>();

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
  public function hide(?id:String, ?opts:Dynamic):Void
  {
    var panel:PanelHandle;
    if (id == null)
      panel = current;
    else if ((panel = panels.get(id)) == null) {
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
      next = null;
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
  //----------------------------------------------------
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
  //----------------------------------------------------
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

  //----------------------------------------------------
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
