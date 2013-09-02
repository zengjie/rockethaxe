package com.rocketshipgames.haxe;

import flash.display.Bitmap;
import flash.events.Event;
import flash.events.KeyboardEvent;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.world.World;

import com.rocketshipgames.haxe.gfx.GraphicsContainer;
import com.rocketshipgames.haxe.gfx.Viewport;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.device.Keyboard;


class ArcadeScreen
  extends com.rocketshipgames.haxe.ui.Screen
{

  //------------------------------------------------------------

  public var world(default, null):World;

  public var time(default,null):Int;
  public var elapsed(default,null):Int;

  public var pauseOnUnfocus:Bool;
  public var pausedBitmap:Bitmap;

  public var viewport(default, null):Viewport;

  //------------------------------------------------------------
  private var graphicsContainers:List<GraphicsContainer>;

  private var paused(default,null):Bool;
  private var clientPaused:Bool;
  private var focusPaused:Bool;
  private var pausedScreenShowing:Bool;

  private var prevFrameTimestamp:Int;


  //------------------------------------------------------------
  public function new(?world:World):Void
  {
    super();

    if (world == null)
      world = new World();
    this.world = world;


    viewport = new Viewport();

    graphicsContainers = new List();


    //-- Setup the game clocks and initial state
    time = 0;
    elapsed = 0;

    paused = false;
    clientPaused = false;
    pauseOnUnfocus = true;
    focusPaused = false;
    pausedScreenShowing = false;
    pausedBitmap = null;

    prevFrameTimestamp = flash.Lib.getTimer();

    //-- Setup the events that make everything happen
    var stage = flash.Lib.current.stage;
    // // stage.addEventListener(Event.ADDED_TO_STAGE, onAdded);
    stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    stage.addEventListener(Event.ACTIVATE, onActivate);
    stage.addEventListener(Event.DEACTIVATE, onDeactivate);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, Keyboard.onKeyDown);
    stage.addEventListener(KeyboardEvent.KEY_UP, Keyboard.onKeyUp);

    // end new
  }

  //------------------------------------------------------------
  public function stop():Void
  {

    var stage = flash.Lib.current.stage;
    // stage.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
    stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    stage.removeEventListener(Event.ACTIVATE, onActivate);
    stage.removeEventListener(Event.DEACTIVATE, onDeactivate);

    stage.removeEventListener(KeyboardEvent.KEY_DOWN, Keyboard.onKeyDown);
    stage.removeEventListener(KeyboardEvent.KEY_UP, Keyboard.onKeyUp);

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
  //------------------------------------------------------------
  /*
  private function onAdded(e:Event=null):Void
  {
    paused = false;
    prevFrameTimestamp = flash.Lib.getTimer();
    // end function onStage
  }
  */

  private function onActivate(e:Event=null):Void
  {
    focusPaused = false;
    updatePaused();
    // end onActivate
  }
  private function onDeactivate(e:Event=null):Void
  {
    if (pauseOnUnfocus) {
      focusPaused = true;
      updatePaused();
    }
    // end onDeactivate
  }

  //------------------------------------------------------------
  private function showPausedScreen():Void
  {
    if (pausedBitmap == null) {
      pausedBitmap =
        com.rocketshipgames.haxe.gfx.text.TextBitmap.makeBitmap("- PAUSED -");
    }

    pausedBitmap.x = (Display.width-pausedBitmap.width)/2;
    pausedBitmap.y = 3*(Display.height-pausedBitmap.height)/8;
    addChild(pausedBitmap);

    pausedScreenShowing = true;
    // end showPausedScreen
  }

  private function hidePausedScreen():Void
  {
    if (!pausedScreenShowing) {
      Debug.error("Tried to hide pause screen while not showing.");
      return;
    }

    removeChild(pausedBitmap);
    pausedScreenShowing = false;
    // end hidePausedScreen
  }

  //------------------------------------------------------------
  public function togglePaused(?showScreen:Bool)
  {
    setPaused(!clientPaused, showScreen);
    // end pause
  }

  public function setPaused(paused:Bool = true, ?showScreen:Bool)
  {
    clientPaused = paused;
    updatePaused(showScreen);
    // end pause
  }

  private function enterPaused():Void
  {
    // end enterPaused
  }

  private function leavePaused():Void
  {
    // end leavePaused
  }

  private function updatePaused(showScreen:Bool = true):Void
  {
    var p:Bool = clientPaused || focusPaused;

    if (!p && paused) {
      if (pausedScreenShowing)
        hidePausedScreen();

      leavePaused();

      // If we're starting back up, we need to adjust the clock so
      // that the game doesn't warp speed ahead the paused interval.
      prevFrameTimestamp = flash.Lib.getTimer();

    } else if (p && !paused) {
      #if !nopausescreen
        if (showScreen)
          showPausedScreen();
      #end

      enterPaused();
    }

    paused = p;
    // end updatePaused
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function onEnterFrame(e:Event=null):Void
  {

    if (!paused) {
      var currTime:Int = flash.Lib.getTimer();
      elapsed = currTime - prevFrameTimestamp;
      time += elapsed;
      prevFrameTimestamp = currTime;

      world.update(elapsed);

      // end not paused
    } else {
      elapsed = 0;
    }

    // User game loop stuff should still happen, only entities don't
    // update when paused.  Otherwise, you couldn't unpause...
    update();

    // Show the fancy graphics!
    render();

    // end onEnterFrame
  }


  //------------------------------------------------------------
  private function update():Void
  {
    // Empty function for user to override.
    // end update
  }


  //------------------------------------------------------------
  private function render():Void
  {
    graphics.clear();
    for (gc in graphicsContainers) {
      gc.render(graphics, viewport);
    }
    // end render
  }

  // end ArcadeScreen
}
