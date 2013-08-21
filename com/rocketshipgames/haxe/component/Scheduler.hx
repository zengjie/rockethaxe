package com.rocketshipgames.haxe.component;


class Scheduler
  implements Component
{

  public static final var CAPABILITY_ID:String = "_scheduler_";

  private var container:ComponentHandle;

  private var events:Heap<ScheduledEvent>;


  //----------------------------------------------------
  public var time(default,null):Int;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    events = new Heap(earlier);

    //-- Setup the game clocks and initial state
    time = 0;

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
  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {

    time += elapsed;

    // Run all scheduled events that have come due
    var event:ScheduledEvent;
    while ((event = events.peek()) != null && event.time >= time) {
      event = events.pop();
      event.fire();
    }

    // end update
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function earlier(a:ScheduledEvent, b:ScheduledEvent):Bool
  {
    return (a.time < b.time);
    // end earlier
  }

  public function schedule(t:Int, event:Event):EventTicket
  {
    var sched = new ScheduledEvent(time+t, event);
    events.add(sched);
    return sched;
    // end schedule
  }

  public function scheduleAt(t:Int, event:Event):EventTicket
  {
    var sched = new ScheduledEvent(t, event);
    events.add(sched);
    return sched;
    // end schedule
  }

  // end Scheduler
}


//----------------------------------------------------------------------
//----------------------------------------------------------------------
private class ScheduledEvent
  implements EventTicket
{
  public var time:Int;
  public var event:Event;

  public var cancelled:Bool;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(time:Int, event:Event):Void
  {
    this.time = time;
    this.event = event;
    this.cancelled = false;
  }


  //----------------------------------------------------
  public function cancel():Void
  {
    cancelled = true;
  }

  //----------------------------------------------------
  public function fire():Void
  {
    if (!cancelled)
      event();
  }

  // end ScheduledEvent
}
