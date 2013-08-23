package com.rocketshipgames.haxe.world;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.Component;

import com.rocketshipgames.haxe.component.SignalDispatcher;
import com.rocketshipgames.haxe.component.StateKeeper;
import com.rocketshipgames.haxe.component.Scheduler;


class World
{

  //----------------------------------------------------
  public var entities(default, null):ComponentContainer;

  public var mechanics(default, null):ComponentContainer;

  public var signals(default, null):SignalDispatcher;

  public var states(default, null):StateKeeper;

  public var scheduler(default, null):Scheduler;


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void
  {

    entities = new ComponentContainer();
    mechanics = new ComponentContainer();

    signals = new SignalDispatcher();
    states = new StateKeeper();
    scheduler = new Scheduler();

    // end new
  }


  //------------------------------------------------------------
  public function update(elapsed:Int):Void
  {
    entities.update(elapsed);
    mechanics.update(elapsed);
    // end update
  }

  // end World
}
