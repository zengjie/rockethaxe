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

package com.rocketshipgames.haxe.text.widgets;

import nme.Assets;

import nme.utils.Timer;
import nme.events.TimerEvent;
import nme.events.Event;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;

import nme.text.Font;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;

enum FlyingTextHorizontalDirection {
  FLY_DEFAULT;
  FLY_LEFT;
  FLY_RIGHT;
}

enum FlyingTextVerticalDirection {
  FLY_DEFAULT;
  FLY_TOP;
  FLY_BOTTOM;
}

class FlyingTextList
  extends Sprite,
  implements TextReceiver
{

  //------------------------------------------------------------
  public static inline var DEFAULT_PRE_INTERVAL:Float = 1;
  public static inline var DEFAULT_FLYIN_INTERVAL:Float = 2;
  public static inline var DEFAULT_DELAY_INTERVAL:Float = 2;
  public static inline var DEFAULT_FLYOUT_INTERVAL:Float = 2;
  public static inline var DEFAULT_POST_INTERVAL:Float = 1;

  public static inline var DEFAULT_DIRECTION:FlyingTextHorizontalDirection
    = FLY_LEFT;

  public var alternate:Bool = true;
  public var direction:FlyingTextHorizontalDirection;
  public var loop:Bool = true;
  public var overrideDirection:Bool = false;

  public var leftBounds:Float;
  public var rightBounds:Float;
  public var baseline:Float;

  public var verticalJustification:FlyingTextVerticalDirection;

  //------------------------------------------------------------
  private var texts:List<FlyingText> = null;
  private var cursor:Iterator<FlyingText>;

  private var timer:Timer = null;

  private var onCompleteCallback:Void->Void = null;

  private var current:FlyingText = null;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(xml:String=null,
                      leftBounds:Float = 0,
                      rightBounds:Float = -1,
                      baseline:Float = -1,
                      defaultOpts:Dynamic = null):Void
  {
    super();
    texts = new List();

    direction = DEFAULT_DIRECTION;
    verticalJustification = FLY_DEFAULT;

    this.leftBounds = leftBounds;

    if (rightBounds == -1)
      this.rightBounds = nme.Lib.current.stage.stageWidth;
    else
      this.rightBounds = rightBounds;

    if (baseline == -1)
      this.baseline = nme.Lib.current.stage.stageHeight/2;
    else
      this.baseline = baseline;

    if (xml != null)
      parseXMLList(xml, defaultOpts);
    // end new
  }

  public function onComplete(cb:Void->Void)
  {
    onCompleteCallback = cb;
    // end onComplete
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function parseXMLList(xml:String, defaultOpts:Dynamic = null)
  {
    if (defaultOpts == null)
      defaultOpts = {};

    //trace("Parsing text list.");
    var root = Xml.parse(xml).firstElement();
    for (cmd in root.elementsNamed("text")) {
      var str:String = cmd.firstChild().nodeValue;

      //trace("text '" + str + "'");
      var opts:Dynamic = Reflect.copy(defaultOpts);

      for (att in cmd.attributes()) {
        //trace("  " + att + ":" + cmd.get(att));

        Reflect.setField(opts, att, cmd.get(att));

        // end looping attributes
      }

      receiveText(str, opts);

      // end iterating over text
    }
    // end parseXMLList
  }

  //------------------------------------------------------------
  public function receiveText(text:String, opts:Dynamic=null)
  {
    texts.add(new FlyingText(text, opts));
    // end receiveText
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function start()
  {
    this.visible = true;
    cursor = texts.iterator();
    pre();
    // end start
  }

  public function stop()
  {
    if (current != null) {
      Actuate.stop(current.bitmap, null, false, false);
      if (contains(current.bitmap))
        removeChild(current.bitmap);
      else
        //trace("Tried to remove non-existant child; '" + current.text + "'");
      current = null;
    }

    if (timer != null) {
      timer.stop();
      timer = null;
    }

    this.visible = false;
    // end stop
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private function pre(e:Event = null)
  {
    //trace("pre");

    if (!cursor.hasNext()) {
      if (texts.length <= 0) {
        return;
      }

      if (onCompleteCallback != null)
        onCompleteCallback();

      if (!loop)
        return;

      cursor = texts.iterator();
    }

    current = cursor.next();
    addChild(current.bitmap);
    current.bitmap.visible = false;

    timer = new Timer(Std.int(current.pre*1000), 1);
    timer.addEventListener(TimerEvent.TIMER, flyin);
    timer.start();

    // end scheduleNext
  }

  private function flyin(e:Event = null)
  {
    //trace("flyin '" + current.text + "'");

    var dir:FlyingTextHorizontalDirection;

    if (current.flyinDirection == FLY_DEFAULT ||
        overrideDirection)
      dir = direction;
    else
      dir = current.flyinDirection;

    if (alternate)
      direction = (direction==FLY_LEFT) ? FLY_RIGHT : FLY_LEFT;

    if (dir == FLY_LEFT)
      current.bitmap.x = rightBounds;
    else
      current.bitmap.x = leftBounds - current.bitmap.width;

    switch (verticalJustification) {
    case FLY_DEFAULT: {
      current.bitmap.y = baseline - (current.bitmap.height/2);
    }
    case FLY_TOP: {
      current.bitmap.y = baseline;
    }
    case FLY_BOTTOM: {
      current.bitmap.y = baseline - current.bitmap.height;
    }
    }

    current.bitmap.alpha = 1;
    current.bitmap.visible = true;

    Actuate.tween(current.bitmap, current.flyin,
                  {x: ((rightBounds-leftBounds)-current.bitmap.width)/2})
      .ease(Cubic.easeOut)
      .onComplete(delay);

    // end flyin
  }

  private function delay()
  {
    //trace("delay '" + current.text + "'");

    timer = new Timer(Std.int(current.delay*1000), 1);
    timer.addEventListener(TimerEvent.TIMER, flyout);
    timer.start();
    // end delay
  }

  private function flyout(e:Event = null)
  {
    //trace("flyout '" + current.text + "'");
    var dir:FlyingTextHorizontalDirection;

    if (current.flyinDirection == FLY_DEFAULT ||
        overrideDirection)
      dir = direction;
    else
      dir = current.flyinDirection;

    Actuate.tween(current.bitmap, current.flyout,
                  {x: (dir==FLY_LEFT) ? -current.bitmap.width : rightBounds})
      .ease(Cubic.easeIn)
      .onComplete(post);

    // end flyout
  }

  private function post()
  {
    //trace("post '" + current.text + "'");

    current.bitmap.visible = false;
    removeChild(current.bitmap);

    timer = new Timer(Std.int(current.post)*1000, 1);
    timer.addEventListener(TimerEvent.TIMER, pre);
    timer.start();

    current = null;
    // end delay
  }

  // end FlyingTextList
}

//----------------------------------------------------------------------
//--------------------------------------------------------------
private class FlyingText {
  public var text:String;

  public var pre:Float = FlyingTextList.DEFAULT_PRE_INTERVAL;
  public var flyin:Float = FlyingTextList.DEFAULT_FLYIN_INTERVAL;
  public var delay:Float = FlyingTextList.DEFAULT_DELAY_INTERVAL;
  public var flyout:Float = FlyingTextList.DEFAULT_FLYOUT_INTERVAL;
  public var post:Float = FlyingTextList.DEFAULT_POST_INTERVAL;

  public var flyinDirection:FlyingTextHorizontalDirection;
  public var flyoutDirection:FlyingTextHorizontalDirection;

  public var bitmap:Bitmap = null;

  public function new(text:String, opts:Dynamic=null):Void
  {
    this.text = text;
    flyinDirection = FLY_DEFAULT;
    flyoutDirection = FLY_DEFAULT;

    if (opts != null) {
      if (Reflect.hasField(opts, "pre")) {
        var d:Dynamic = Reflect.field(opts, "pre");
        pre = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }

      if (Reflect.hasField(opts, "flyin")) {
        var d:Dynamic = Reflect.field(opts, "flyin");
        flyin = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }

      if (Reflect.hasField(opts, "delay")) {
        var d:Dynamic = Reflect.field(opts, "delay");
        delay = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }

      if (Reflect.hasField(opts, "flyout")) {
        var d:Dynamic = Reflect.field(opts, "flyout");
        flyout = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }

      if (Reflect.hasField(opts, "post")) {
        var d:Dynamic = Reflect.field(opts, "post");
        post = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }

      if (Reflect.hasField(opts, "flyin-dir")) {
        var d:String = Reflect.field(opts, "flyin-dir");
        if (d == "left") {
          flyinDirection = FLY_LEFT;
        } else if (d == "right") {
          flyinDirection = FLY_RIGHT;
        }
      }

      if (Reflect.hasField(opts, "flyout-dir")) {
        var d:String = Reflect.field(opts, "flyout-dir");
        if (d == "left") {
          flyoutDirection = FLY_LEFT;
        } else if (d == "right") {
          flyoutDirection = FLY_RIGHT;
        }
      }

      if (Reflect.hasField(opts, "font")) {
        var d:String = Reflect.field(opts, "font");
        var f:Font = Assets.getFont(d);
        Reflect.setField(opts, "font", f.fontName);
      }

      // end was given opts
    }


    bitmap = TextBitmap.makeBitmap(this.text, opts);
    // end new
  }

  // end FlyingText
}
