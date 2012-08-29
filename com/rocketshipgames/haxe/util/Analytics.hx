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

package com.rocketshipgames.haxe.util;

import com.rocketshipgames.haxe.debug.Debug;

import nme.display.DisplayObject;

#if flash
import com.google.analytics.AnalyticsTracker; 
import com.google.analytics.GATracker;

class Analytics
{

  private static var tracker:AnalyticsTracker = null;
  private static var game:String;
  private static var error:Dynamic;

  public static function connect(gameRoot:DisplayObject,
                          gameID:String,
                          gameLabel:String):Void
  {
    game = gameLabel;
    try {
      tracker = new GATracker(gameRoot, gameID, "AS3", false);
      event("load");
    } catch (e:Dynamic) {
      Debug.error("Could not connect to analytics: " + e);
    }
    // end connect
  }

  public static function event(eventID:String, vars:Dynamic=null):Void
  {
    if (tracker == null || !tracker.isReady())
      return;

    var str:String = "";
    if (vars != null) {
      for (f in Reflect.fields(vars)) {
        str += f + "=" + Reflect.field(vars, f) + "&";
      }
      str = str.substr(0, str.length-1);
    }

    try {
      tracker.trackEvent(game, eventID, str);
    } catch (e:Dynamic) {
      Debug.error("Could not post to analytics: " + e);
    }

    // end event
  }

  public static function pageView(eventID:String, vars:Dynamic=null):Void
  {
    if (tracker == null || !tracker.isReady())
      return;

    var str:String = "/"+game+"/"+eventID;
    if (vars != null) {
      str += "?";

      for (f in Reflect.fields(vars)) {
        str += f + "=" + Reflect.field(vars, f) + "&";
      }
      str = str.substr(0, str.length-1);
    }

    try {
      tracker.trackPageview(str);
    } catch (e:Dynamic) {
      Debug.error("Could not post to analytics: " + e);
    }

    // end pageView
  }

  // end Analytics
}

// end flash
#else

class Analytics
{

  public static function connect(root:DisplayObject,
                          gameID:String,
                          gameLabel:String):Void
  {
    // end connect
  }

  public static function event(eventID:String):Void
  {
    // end event
  }

  public static function pageView(eventID:String):Void
  {
    // end page
  }

  // end Analytics
}

#end

