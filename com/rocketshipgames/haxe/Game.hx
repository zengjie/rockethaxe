package com.rocketshipgames.haxe;

import com.rocketshipgames.haxe.device.Display;

import com.rocketshipgames.haxe.ui.ScreenManager;


class Game
{

  public function new():Void
  {
    #if verbose
      haxe.Log.trace("New Game");
    #end

    // Set up the display coordinate system and get dimensions
    Display.configureStandard();

    // Play a zero-volume sound to initialize the audio system.  Some
    // platforms (i.e., Flash) have a delay on the first sound played.

    // Turn off the mouse?
    flash.ui.Mouse.hide();

    // ScreenManager organizes what is currently on display
    ScreenManager.initialize();

    // end new
  }

  // end Game
}
