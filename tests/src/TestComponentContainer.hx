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
      trace("Thing " + cast(x.component, Thing).id);
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

  public function attach(containerHandle:ComponentHandle):Void
  {
    trace("Attach " + id);
  }

  public function detach():Void
  {
    trace("Detach " + id);
  }

  public function update(elapsed:Int):Void
  {
    trace("Update " + id + ": " + elapsed);
  }

  // end Thing
}
