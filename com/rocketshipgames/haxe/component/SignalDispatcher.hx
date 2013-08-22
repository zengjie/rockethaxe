package com.rocketshipgames.haxe.component;


class SignalDispatcher
  implements Component
{

  public static var CAPABILITY_ID:String = "dispatcher";

  private var container:ComponentHandle;

  private var signals:Map<String, List<Signal>>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    signals = new Map();
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

  public function update(elapsed:Int):Void
  {
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addSignal(id:String, signal:Signal):Signal
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

  public function removeSignal(id:String, signal:Signal):Void
  {
    var a:List<Signal> = signals.get(id);
    if (a != null) {
      a.remove(signal);
    }
    // end removeSignal
  }

  public function signal(id:String, msg:Dynamic):Void
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

  // end SignalDispatcher
}
