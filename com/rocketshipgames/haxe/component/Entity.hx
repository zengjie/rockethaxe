package com.rocketshipgames.haxe.component;


class Entity
  extends ComponentContainer
{

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    super();
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public override function findCapability(capability:CapabilityID,
                                          necessary:Bool=true):Component
  {
    var x = findCapabilityHandle(capability, necessary);
    if (x != null)
      return x.component;
    return null;
    // end findCapability
  }

  public override function findCapabilityHandle
    (capability:CapabilityID,
     necessary:Bool=true):ComponentHandle
  {

    if (capability == SignalDispatcher.CID_SIGNALS ||
        capability == StateKeeper.CID_STATES ||
        capability == Scheduler.CID_EVENTS)
      necessary = false;

    var res = super.findCapabilityHandle(capability, necessary);

    if (res == null) {

      if (capability == SignalDispatcher.CID_SIGNALS) {
        res = addComponent(new SignalDispatcher());

      } else if (capability == StateKeeper.CID_STATES) {
        res = addComponent(new StateKeeper());

      } else if (capability == Scheduler.CID_EVENTS) {
        res = addComponent(new Scheduler());
      }

    }

    // end findCapability
    return res;
  }

  // end Entity
}
