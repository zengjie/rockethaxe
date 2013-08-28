package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.util.Jenkins;


// Returning true on activation removes the signal.
typedef Signal = SignalID->Dynamic->Bool;


typedef SignalID = Int;


class SignalDispatcher
  implements Component
{

  public static var CID:CapabilityID = ComponentContainer.hashID("_signals_");

  private var container:ComponentHandle;

  private var signals:Map<SignalID, List<Signal>>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    signals = new Map();
    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function hashID(id:String):SignalID
  {
    return Jenkins.hash32(id);
    // end hashID
  }

  public static function reverseID(id:CapabilityID):String
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
  public function add(id:SignalID, signal:Signal):Signal
  {
    var a:List<Signal> = signals.get(id);
    if (a == null) {
      a = new List();
      signals.set(id, a);
    }
    a.push(signal);

    return signal;
    // end addSignal
  }

  public function remove(id:SignalID, signal:Signal):Void
  {
    var a:List<Signal> = signals.get(id);
    if (a != null) {
      a.remove(signal);
    }
    // end removeSignal
  }

  public function signal(id:SignalID, msg:Dynamic):Void
  {
    var a:List<Signal> = signals.get(id);
    if (a != null) {
      for (signal in a) {
        if (signal(id, msg))
          a.remove(signal);
      }
    }
    // end signal
  }


  //----------------------------------------------------
  public function addByID(id:String, signal:Signal):Signal
  {
    return add(hashID(id), signal);
  }

  public function removeByID(id:String, signal:Signal):Void
  {
    remove(hashID(id), signal);
  }

  public function signalByID(id:String, msg:Dynamic):Void
  {
    signal(hashID(id), msg);
  }

  // end SignalDispatcher
}
