package ;

import com.rocketshipgames.haxe.component.Entity;
import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentHandle;

import com.rocketshipgames.haxe.component.SignalDispatcher;
import com.rocketshipgames.haxe.component.StateKeeper;
import com.rocketshipgames.haxe.component.State;
import com.rocketshipgames.haxe.component.Scheduler;


class TestEntity
{

  public static function main():Void
  {

    trace("Test Entity");

    var world = new Entity();

    trace("Testing signal dispatcher");
    world.addComponent(new SignalSink());
    world.addComponent(new SignalSource());


    trace("Testing state keeper");
    var keeper = cast(world.findCapability(StateKeeper.CID_STATES),
                      StateKeeper);
    keeper.addState("feeling", new TestState());

    trace("Feeling " + keeper.getStateValue("feeling"));


    trace("Testing scheduler");
    var scheduler = cast(world.findCapability(Scheduler.CID_EVENTS),
                         Scheduler);

    scheduler.schedule(100, function():Void { trace("EVENT FIRED!"); });

    world.update(100);  // Evolve the world forward


    // end main
  }

}


class SignalSink
  implements Component
{
  public function new():Void
  {
    trace("New signal sink");
  }

  public function attach(containerHandle:ComponentHandle):Void
  {
    var dispatcher = cast(containerHandle.findCapability
                          (SignalDispatcher.CID_SIGNALS),
                          SignalDispatcher);
    dispatcher.addSignal(SignalDispatcher.hashID("lightning"),
                         function(s:SignalID, opts:Dynamic):Bool
                         {
                           trace("Lightning strikes!  Signal received.");
                           return false;
                         });
    // end attach
  }

  public function detach():Void {}

  public function activate(?opts:Dynamic):Void {}

  public function deactivate():Void {}

  public function update(elapsed:Int):Void {}

  // end SignalSink
}


class SignalSource
  implements Component
{
  public function new():Void
  {
    trace("New signal source");
  }

  public function attach(containerHandle:ComponentHandle):Void
  {
    var dispatcher = cast(containerHandle.findCapability
                          (SignalDispatcher.CID_SIGNALS),
                          SignalDispatcher);
    dispatcher.signalID("lightning", {});
    // end attach
  }

  public function detach():Void {}

  public function activate(?opts:Dynamic):Void {}

  public function deactivate():Void {}

  public function update(elapsed:Int):Void {}

  // end SignalSource
}


class TestState
  implements State
{

  public function new():Void
  {
  }

  public function getValue(id:String):Dynamic
  {
    return "happy";
  }

  public function remove(id:String):Void
  {
  }

  // end TestState
}
