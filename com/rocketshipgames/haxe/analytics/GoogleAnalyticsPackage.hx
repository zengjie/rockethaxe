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

package com.rocketshipgames.haxe.analytics;

import com.rocketshipgames.haxe.debug.Debug;

import nme.display.DisplayObject;

import com.google.analytics.AnalyticsTracker; 
import com.google.analytics.GATracker;


class GoogleAnalyticsPackage
  implements AnalyticsPackage
{

  private var tracker:AnalyticsTracker;
  private var category:String;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:DisplayObject,
                      propertyID:String,
                      category:String):Void
  {
    this.category = category;

    try {
      tracker = new GATracker(container, propertyID, "AS3", false);
    } catch (e:Dynamic) {
      Debug.error("Could not connect to Google Analytics: " + e);
    }

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function event(eventID:String,
                        vars:Dynamic=null,
                        ?value:Float=null):Void
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
      tracker.trackEvent(category, eventID, str, value);
      #if debug
        trace("Event " + category + ":" + eventID + " -> " +
              str + ((value != null) ? (" " + value) : ""));
      #end
    } catch (e:Dynamic) {
      Debug.error("Could not post to Google Analytics: " + e);
    }

    // end event
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function pageView(eventID:String, vars:Dynamic=null):Void
  {
    if (tracker == null || !tracker.isReady())
      return;

    var str:String = "/"+category+"/"+eventID;
    if (vars != null) {
      str += "?";

      for (f in Reflect.fields(vars)) {
        str += f + "=" + Reflect.field(vars, f) + "&";
      }
      str = str.substr(0, str.length-1);
    }

    try {
      tracker.trackPageview(str);
      #if debug
        trace("Pageview " + str);
      #end
    } catch (e:Dynamic) {
      Debug.error("Could not post to Google Analytics: " + e);
    }

    // end pageView
  }

  // end GoogleAnalyticsPackage
}
