/*
 * Copyright (c) 2012 Joe Kopena <tjkopena@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.rocketshipgames.haxe;

import nme.Lib;

import com.rocketshipgames.haxe.gfx.Screen;

import com.rocketshipgames.haxe.debug.Debug;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;

import com.rocketshipgames.haxe.Signal;
import com.rocketshipgames.haxe.State;

import com.rocketshipgames.haxe.gfx.GraphicsContainer;

import com.rocketshipgames.haxe.ui.Keyboard;

class GameLoop
  extends Sprite,
  implements World
{

  //------------------------------------------------------------
  public var worldWidth(default,null):Float;
  public var worldHeight(default,null):Float;

  public var displayWidth(default,null):Int;
  public var displayHeight(default,null):Int;

  public var time(default,null):Int;
  public var elapsed(default,null):Int;

  public var entityCount(default,null):Int;

  public var pauseOnUnfocus:Bool;


  //------------------------------------------------------------
  private var graphicsContainers:List<GraphicsContainer>;

  private var entitiesTail:Entity;
  private var entitiesHead:Entity;

  private var signals:Hash<List<Signal>>;
  private var states:Hash<State>;
  private var timers:List<Timer>;

  private var paused:Bool;

  private var prevFrameTimestamp:Int;

  //------------------------------------------------------------
  public function new(worldWidth:Float=0, worldHeight:Float=0,
                      displayWidth:Int=0, displayHeight:Int=0):Void
  {
    super();

    //-- Setup the world dimensions
    if (worldWidth == 0)
      this.worldWidth = Screen.width;
    else
      this.worldWidth = worldWidth;

    if (worldHeight == 0)
      this.worldHeight = Screen.height;
    else
      this.worldHeight = worldHeight;


    //-- Setup the display dimensions; note this isn't necessarily the
    //   same as the screen dimensions, hence the option.
    if (displayWidth == 0)
      this.displayWidth = Std.int(this.worldWidth);
    else
      this.displayWidth = displayWidth;

    if (displayHeight == 0)
      this.displayHeight = Std.int(this.worldHeight);
    else
      this.displayHeight = displayHeight;


    //-- Setup the basic game containers
    graphicsContainers = new List();

    entitiesHead = entitiesTail = null;
    entityCount = 0;

    signals = new Hash();
    states = new Hash();
    timers = new List();


    //-- Setup the game clocks and initial state
    time = 0;
    elapsed = 0;

    pauseOnUnfocus = true;
    paused = false;

    prevFrameTimestamp = Lib.getTimer();

    //-- Setup the events that make everything happen
    var stage = Lib.current.stage;
    // stage.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    stage.addEventListener(KeyboardEvent.KEY_DOWN, Keyboard.onKeyDown);
    stage.addEventListener(KeyboardEvent.KEY_UP, Keyboard.onKeyUp);
    stage.addEventListener(Event.ACTIVATE, onActivate);
    stage.addEventListener(Event.DEACTIVATE, onDeactivate);

    // end new
  }

  //------------------------------------------------------------
  public function stop():Void
  {
    var stage = Lib.current.stage;
    // stage.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
    stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    stage.removeEventListener(KeyboardEvent.KEY_DOWN, Keyboard.onKeyDown);
    stage.removeEventListener(KeyboardEvent.KEY_UP, Keyboard.onKeyUp);
    stage.removeEventListener(Event.ACTIVATE, onActivate);
    stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
    // end stop
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addGraphicsContainer(gc:GraphicsContainer):Void
  {
    graphicsContainers.add(gc);
    // end addGraphicsContainer
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


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  /*
  private function onAdded(e:Event=null):Void
  {
    paused = false;
    prevFrameTimestamp = Lib.getTimer();
    // end function onStage
  }
  */

  private function onActivate(e:Event=null):Void
  {
    setPaused(false);
    // end onActivate
  }
  private function onDeactivate(e:Event=null):Void
  {
    setPaused(true);
    // end onDeactivate
  }

  //------------------------------------------------------------
  public function togglePaused()
  {
    setPaused(!paused);
    // end pause
  }

  public function setPaused(paused:Bool = true)
  {
    if (!paused && this.paused) {
      // If we're starting back up, we need to adjust the clock so
      // that the game doesn't warp speed ahead the paused interval.
      prevFrameTimestamp = Lib.getTimer();
    }

    this.paused = paused;
    // end pause
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function onEnterFrame(e:Event=null):Void
  {

    if (!paused) {
      var currTime:Int = Lib.getTimer();
      elapsed = currTime - prevFrameTimestamp;
      time += elapsed;
      prevFrameTimestamp = currTime;

      for (t in timers)
        t.update(elapsed);

      var curr:Entity = entitiesHead;
      var next:Entity;
      while (curr != null) {
        next = curr.nextEntity; // Cache this in case curr gets removed
        // but it also means new entities won't get processed...
        curr.update(elapsed);
        curr = next;
        // curr = next;
      }

      // end not paused
    } else {
      elapsed = 0;
    }

    // User game loop stuff should still happen, only entities don't
    // update when paused.  Otherwise, you couldn't unpause...
    update();

    render();

    // end onEnterFrame
  }

  private function update():Void
  {
    // Empty function for user to override.
    // end update
  }

  private function render():Void
  {
    graphics.clear();
    for (gc in graphicsContainers) {
      gc.render(graphics, elapsed);
    }
    // end render
  }

  // end GameLoop
}
