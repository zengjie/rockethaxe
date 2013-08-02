package com.rocketshipgames.haxe.world;

import com.rocketshipgames.haxe.debug.Debug;


class World
{

  var width(default,null):Float;
  var height(default,null):Float;

  var time(default,null):Int;

  public var entityCount(default,null):Int;


  //------------------------------------------------------------
  private var entitiesTail:Entity;
  private var entitiesHead:Entity;

  private var signals:Map<String, List<Signal>>;
  private var states:Map<String, State>;
  // private var timers:List<Timer>;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void // width:Float=0, height:Float=0):Void
  {

    /*
    //-- Setup the world dimensions
    if (width == 0)
      this.width = Display.width;
    else
      this.width = width;

    if (height == 0)
      this.height = Display.height;
    else
      this.height = height;
    */

    //-- Setup the basic game containers
    entitiesHead = entitiesTail = null;
    entityCount = 0;

    signals = new Map();
    states = new Map();
    // timers = new List();

    //-- Setup the game clocks and initial state
    time = 0;

    // end new
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function addEntity(e:Entity):Entity
  {
    if (e.prevEntity != null || e.nextEntity != null || entitiesHead == e) {
      Debug.error("Entity already in world.");
      return e;
    }

    if (entitiesTail == null)
      entitiesHead = e;
    else
      entitiesTail.nextEntity = e;

    e.prevEntity = entitiesTail;
    entitiesTail = e;
    e.nextEntity = null;

    entityCount++;

    return e;
    // end addEntity
  }

  public function removeEntity(e:Entity):Void
  {

    if ((e.prevEntity == null && entitiesHead != e) ||
        (e.nextEntity == null && entitiesTail != e)) {
      Debug.error("Entity not in world.");
      return;
    }

    if (e.prevEntity != null)
      e.prevEntity.nextEntity = e.nextEntity;
    else
      entitiesHead = e.nextEntity;

    if (e.nextEntity != null)
      e.nextEntity.prevEntity = e.prevEntity;
    else
      entitiesTail = e.prevEntity;

    e.prevEntity = e.nextEntity = null;

    entityCount--;
    // end removeEntity
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


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addState(id:String, state:State):State
  {
    states.set(id, state);
    return state;
    // end addState
  }

  public function removeState(id:String):Void
  {
    var x:State = states.get(id);
    if (x != null) {
      x.remove(id);
      states.remove(id);
    }
    // end removeState
  }

  public function getState(id:String):State
  {
    return states.get(id);
    // end getState
  }

  public function getStateValue(id:String):Dynamic
  {
    var x:State = states.get(id);
    return ((x == null) ? null : x.getValue(id));
    // end getStateValue
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  /*
  public function addTimer(timer:Timer):Timer
  {
    timers.push(timer);
    timer.setContainer(this);
    return timer;
    // end addTimer
  }

  public function removeTimer(timer:Timer):Void
  {
    timers.remove(timer);
    // end removeTimer
  }
  */


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {

    time += elapsed;

    // Update all timers
    /*
    for (t in timers)
      t.update(elapsed);
    */

    // Update all entities
    var curr:Entity = entitiesHead;
    var next:Entity;
    while (curr != null) {
      next = curr.nextEntity; // Cache this in case curr gets removed
                              // but it also means new entities won't
                              // get processed...

      curr.update(elapsed);
      curr = next;
    }

    // end update
  }

  // end World
}
