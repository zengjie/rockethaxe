package com.rocketshipgames.haxe.component;


class StateKeeper
  implements Component
{

  public static var CAPABILITY_ID:CapabilityID =
    ComponentContainer.hashID("states");

  private var container:ComponentHandle;

  private var states:Map<String, State>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    states = new Map();
    // end new
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    container = containerHandle;
    container.claimCapability(CAPABILITY_ID);
  }

  public function detach():Void
  {
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function update(elapsed:Int):Void
  {
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addState(id:String, state:State):State
  {
    states.set(id, state);
    return state;
    // end addState
  }

  public function removeState(id:String):Void
  {
    var x:State = states.get(id);
    if (x != null) {
      x.remove(id);
      states.remove(id);
    }
    // end removeState
  }

  public function getState(id:String):State
  {
    return states.get(id);
    // end getState
  }

  public function getStateValue(id:String):Dynamic
  {
    var x:State = states.get(id);
    return ((x == null) ? null : x.getValue(id));
    // end getStateValue
  }

  // end StateKeeper
}
