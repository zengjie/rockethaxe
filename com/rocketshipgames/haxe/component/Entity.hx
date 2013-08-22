package com.rocketshipgames.haxe.component;

class Entity
  extends ComponentContainer
  implements Component
{

  private var container:ComponentHandle;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    super();
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public override function findCapability(capability:String):ComponentHandle
  {
    var res = super.findCapability(capability);

    if (res == null) {

      if (capability == SignalDispatcher.CAPABILITY_ID) {
        res = addComponent(new SignalDispatcher());

      } else if (capability == StateKeeper.CAPABILITY_ID) {
        res = addComponent(new StateKeeper());

      } else if (capability == Scheduler.CAPABILITY_ID) {
        res = addComponent(new Scheduler());
      }

    }

    // end findCapability
    return res;
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    container = containerHandle;
  }

  public function detach():Void
  {
  }

  public override function update(elapsed:Int):Void
  {
    logic(elapsed);
    super.update(elapsed);
    // end update
  }

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function logic(elapsed:Int):Void
  {

    // Empty function for users to overload without worrying about
    // call to super.update().

    // end logic
  }

  // end Entity
}
