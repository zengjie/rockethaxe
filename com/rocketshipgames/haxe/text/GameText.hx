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

package com.rocketshipgames.haxe.text;

import nme.Assets;

import nme.display.Bitmap;
import nme.display.BitmapData;

import nme.text.Font;

import com.rocketshipgames.haxe.text.GameTextList;

import com.rocketshipgames.haxe.gfx.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.VerticalAlignment;


class GameText {
  public var text:String;

  public var bitmap:Bitmap;

  public var timer:Int;

  public var duration:Int;
  public var wait:Int;
  public var fadeIn:Int;
  public var fadeOut:Int;

  public var alpha:Float;

  public var horizontalAlignment:HorizontalAlignment;
  public var verticalAlignment:VerticalAlignment;

  public var onComplete:Void->Void;

  public function new(list:GameTextList, text:String, opts:Dynamic=null,
                      predecorator:BitmapData->Void = null,
                      postdecorator:BitmapData->Void = null):Void
  {
    this.text = text;


    if (list != null) {
      duration = list.defaultDuration;
      fadeIn = list.defaultFadeIn;
      fadeOut = list.defaultFadeOut;
      wait = list.defaultWait;

      horizontalAlignment = list.defaultHorizontalAlignment;
      verticalAlignment = list.defaultVerticalAlignment;
    }


    if (opts != null) {

      if (Reflect.hasField(opts, "font")) {
        var d:String = Reflect.field(opts, "font");
        var f:Font = Assets.getFont(d);
        Reflect.setField(opts, "font", f.fontName);
      }

      if (Reflect.hasField(opts, "wait")) {
        var d:Dynamic = Reflect.field(opts, "wait");
        wait = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "duration")) {
        var d:Dynamic = Reflect.field(opts, "duration");
        duration = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "fadeIn")) {
        var d:Dynamic = Reflect.field(opts, "fadeIn");
        fadeIn =  (Std.is(d, String)) ? Std.parseInt(d): d;
      }

      if (Reflect.hasField(opts, "fadeOut")) {
        var d:Dynamic = Reflect.field(opts, "fadeOut");
        fadeOut =  (Std.is(d, String)) ? Std.parseInt(d): d;
      }

      if (Reflect.hasField(opts, "align")) {
        var d:Dynamic = Reflect.field(opts, "align");
        if (Std.is(d, HorizontalAlignment))
          horizontalAlignment = d;
        else
          horizontalAlignment = Type.createEnum(HorizontalAlignment, d);
      }

      if (Reflect.hasField(opts, "valign")) {
        var d:Dynamic = Reflect.field(opts, "valign");
        if (Std.is(d, VerticalAlignment))
          verticalAlignment = d;
        else
          verticalAlignment = Type.createEnum(VerticalAlignment, d);
      }

      onComplete = Reflect.field(opts, "onComplete");

      // end was given opts
    }

    bitmap = TextBitmap.makeBitmap(this.text, opts,
                                   predecorator, postdecorator);
    alpha = 0;
    bitmap.alpha = 0;
    timer = -wait;

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function update(elapsed:Int):Bool
  {
      timer += elapsed;

      if (timer < 0) {
        bitmap.alpha = 0;
      } else if (timer < fadeIn) {
        bitmap.alpha = timer/fadeIn;
      } else if (timer < fadeIn+duration) {
        bitmap.alpha = 1;
      } else if (timer < fadeIn+duration+fadeOut) {
        bitmap.alpha = 1 - (timer-(fadeIn+duration))/fadeOut;
      } else {
        if (onComplete != null)
          onComplete();

        return true;
      }

      /*
      if (timer > (wait + fadeIn + duration + fadeOut)) {
        if (onComplete != null)
          onComplete();

        return true;

      } else if (timer > (wait + fadeIn + duration)) {
        bitmap.alpha =
          1 - (timer - (wait + fadeIn + duration))/fadeOut;

      } else if (timer > wait && timer < (wait + fadeIn)) {
        bitmap.alpha = (timer-wait)/fadeIn;

      } else if (timer < wait) {
        bitmap.alpha = 0;

      } else {
        bitmap.alpha = 1;

      }
      */

      return false;

    // end update
  }

  // end GameText
}
