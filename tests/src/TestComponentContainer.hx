package ;

import com.rocketshipgames.haxe.component.Component;
import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.ComponentHandle;


class TestComponentContainer
{

  public static function main():Void
  {

    trace("Test ComponentContainer");

    var container = new ComponentContainer();

    var ref:ComponentHandle = null;
    for (i in 0...5) {
      var handle = container.addComponent(new Thing(i));

      if (i % 3 == 0) {
        ref = handle;
      }

    }

    container.update(1);

    trace("Removing third");
    ref.remove();

    container.update(2);

    trace("Add another");
    container.addComponent(new Thing(5));

    container.update(3);

    trace("Iterate over");
    for (x in container) {
      trace("Iterate Thing " + cast(x.component, Thing).id);

      cast(x.component, Thing).thingSpecificFunction("TEST");
    }

    trace("Creating magic provider");
    var providers = new ComponentContainer();

    var prov:Provider = new Provider();
    var provHandle = providers.addComponent(prov);

    trace("Looking for magic provider");
    var c:Component = providers.findCapability
      (ComponentContainer.hashID("magic"));
    if (c != null) {
      trace("Magic available");
      cast(c, Provider).magic("story");
    } else {
      trace("No magic available");
    }

    provHandle.remove();

    trace("Looking for magic provider again");
    c = providers.findCapabilityID("magic");
    if (c != null) {
      trace("Magic still available");
    } else {
      trace("No magic available");
    }

    // end main
  }

}


class Thing
  implements Component
{
  public var id:Int;

  public function new(id:Int):Void
  {
    this.id = id;
    trace("New widget " + id);
  }


  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    trace("Attach " + id);
  }

  public function detach():Void
  {
    trace("Detach " + id);
  }


  //--------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //--------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    trace("Update " + id + ": " + elapsed);
  }


  //--------------------------------------------------------------------
  public function thingSpecificFunction(s:String):Void
  {
    trace("Thing " + id + " function " + s);
  }

  // end Thing
}


class Provider
  implements Component
{
  public function new():Void {}

  //--------------------------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    trace("Attach Provider");
    containerHandle.claimCapability(ComponentContainer.hashID("magic"));
    containerHandle.claimCapabilityID("science");
  }

  public function detach():Void
  {
    trace("Detach Provider");
  }


  //--------------------------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
  }

  public function deactivate():Void
  {
  }


  //--------------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    trace("Update Provider: " + elapsed);
  }


  //--------------------------------------------------------------------
  public function magic(s:String):Void
  {
    trace("Provider magic on " + s);
  }

}
