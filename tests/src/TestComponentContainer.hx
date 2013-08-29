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
      var handle = container.add(new Thing(i));

      if (i % 3 == 0) {
        ref = handle;
      }

    }

    container.update(1);

    trace("Removing third");
    ref.remove();

    container.update(2);

    trace("Add another");
    container.add(new Thing(5));

    container.update(3);

    trace("Iterate over");
    for (x in container) {
      trace("Iterate Thing " + cast(x.component, Thing).id);

      cast(x.component, Thing).thingSpecificFunction("TEST");
    }

    trace("Creating magic provider");
    var providers = new ComponentContainer();

    var prov:Provider = new Provider();
    var provHandle = providers.add(prov);

    trace("Looking for magic provider");
    var c:Component = providers.find(ComponentContainer.hashID("magic"));
    if (c != null) {
      trace("Magic available");
      cast(c, Provider).magic("story");
    } else {
      trace("No magic available");
    }

    trace("Detaching provider");
    provHandle.remove();

    trace("Looking for magic provider again");
    c = providers.findByID("magic");
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
    containerHandle.claim(ComponentContainer.hashID("magic"));
    containerHandle.claimByID("science");
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
