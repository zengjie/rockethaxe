package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.util.Jenkins;


class StateKeeper
  implements Component
{

  public static var CID:CapabilityID = ComponentContainer.hashID("cid_states");

  private var container:ComponentHandle;

  private var states:Map<StateID, State>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    states = new Map();
    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function hashID(id:String):StateID
  {
    return Jenkins.hash32(id);
    // end hashID
  }

  public static function reverseID(id:StateID):String
  {
    return Jenkins.reverse32(id);
    // end reverseID
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    container = containerHandle;
    container.claim(CID);
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
  public function add(id:StateID, state:State):State
  {
    states.set(id, state);
    return state;
    // end addState
  }

  public function remove(id:StateID):Void
  {
    var x:State = states.get(id);
    if (x != null) {
      x.remove(id);
      states.remove(id);
    }
    // end removeState
  }

  public function get(id:StateID):State
  {
    return states.get(id);
    // end getState
  }

  public function getValue(id:StateID):Dynamic
  {
    var x:State = states.get(id);
    return ((x == null) ? null : x.getValue(id));
    // end getStateValue
  }

  //------------------------------------------------------------
  public function addByID(id:String, state:State):State
  {
    return add(hashID(id), state);
  }

  public function removeByID(id:String):Void
  {
    remove(hashID(id));
  }

  public function getByID(id:String):State
  {
    return get(hashID(id));
  }

  public function getValueByID(id:String):Dynamic
  {
    return getValue(hashID(id));
  }

  // end StateKeeper
}
