/*
 * Copyright (c) 2011 Joe Kopena <tjkopena@gmail.com>
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

import nme.geom.Rectangle;
import nme.geom.Matrix;

import nme.display.Bitmap;
import nme.display.BitmapData;

import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

class TextBitmap {

  public static inline var DEFAULT_FONT:String = "assets/fonts/nokiafc22.ttf";

  public static var defaultBackgroundColor:Int = 0x00000000;
  public static var defaultSize:Int = 16;
  public static var defaultColor:Int = 0xffffffff;
  public static var defaultFont:Font = null;

  //------------------------------------------------------------
  public var bitmap:BitmapData = null;

  //------------------------------------------------------------
  private var tf:TextField;
  private var format:TextFormat;

  private var fontName:String;
  private var size:Int;
  private var color:Int;
  private var bgcolor:Int;

  private var width:Int;
  private var height:Int;

  private var marginLeft:Int;
  private var marginRight:Int;
  private var marginTop:Int;
  private var marginBottom:Int;

  private var predecorator:BitmapData->Void;
  private var postdecorator:BitmapData->Void;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(string:String,
                      opts:Dynamic=null,
                      predecorator:BitmapData->Void=null,
                      postdecorator:BitmapData->Void=null):Void
  {
    tf = new TextField();

    size = defaultSize;
    color = defaultColor;
    bgcolor = defaultBackgroundColor;

    marginLeft = 0;
    marginRight = 0;
    marginTop = 0;
    marginBottom = 0;

    width = 0;
    height = 0;

    // This is not packed into the following opts != null check so
    // that it can set a default if there are no opts.  It's not just
    // set like the others to avoid the Assets hash
    if (opts != null && Reflect.hasField(opts, "font")) {
      fontName = Reflect.field(opts, "font");
    } else {
      if (defaultFont == null)
        defaultFont = Assets.getFont(DEFAULT_FONT);
      fontName = defaultFont.fontName;
    }

    if (opts != null) {
      if (Reflect.hasField(opts, "size")) {
        var d:Dynamic = Reflect.field(opts, "size");
        size = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "color")) {
        var d:Dynamic = Reflect.field(opts, "color");
        color = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "bgcolor")) {
        var d:Dynamic = Reflect.field(opts, "bgcolor");
        bgcolor = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "margin")) {
        var d:Dynamic = Reflect.field(opts, "margin");
        marginLeft = marginRight = marginTop = marginBottom =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if (Reflect.hasField(opts, "marginLeft")) {
        var d:Dynamic = Reflect.field(opts, "marginLeft");
        marginLeft = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if (Reflect.hasField(opts, "marginRight")) {
        var d:Dynamic = Reflect.field(opts, "marginRight");
        marginRight = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if (Reflect.hasField(opts, "marginTop")) {
        var d:Dynamic = Reflect.field(opts, "marginTop");
        marginTop = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if (Reflect.hasField(opts, "marginBottom")) {
        var d:Dynamic = Reflect.field(opts, "marginBottom");
        marginBottom = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "width")) {
        var d:Dynamic = Reflect.field(opts, "width");
        width = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if (Reflect.hasField(opts, "height")) {
        var d:Dynamic = Reflect.field(opts, "height");
        height = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      // end has opts
    }

    /*
    // This does not compile because of some problems in the
    // way neash defines TextFormalAlign.

    var justification:TextFormatAlign = TextFormatAlign.LEFT;
    if (Reflect.hasField(opts, "justification")) {
      var d:Dynamic = Reflect.field(opts, "justification");
      if (Std.is(d, TextFormatAlign))
        justification = d;
      else if (d == "left")
        justification = TextFormatAlign.LEFT;
      else if (d == "right")
        justification = TextFormatAlign.RIGHT;
      else if (d == "center")
        justification = TextFormatAlign.CENTER;
      else if (d == "justify")
        justification = TextFormatAlign.JUSTIFY;
      else
        Debug.error("Unknown justification " + d);
      // end justification opt
    }
    */

    format = new TextFormat(fontName, size, color);

    // Doing this here works around the compilation problem with
    // TextFormatAlign noted above.
    if (opts != null && Reflect.hasField(opts, "justification")) {
      format.align = Reflect.field(opts, "justification");
    }

    tf.embedFonts = true;
    tf.defaultTextFormat = format;
    tf.autoSize = LEFT;

    this.predecorator = predecorator;
    this.postdecorator = postdecorator;

    draw(string);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function draw(string:String):Void
  {

    tf.text = string;

    var w:Int;
    if (width == 0)
      w = Std.int(tf.width) + marginLeft + marginRight;
    else
      w = width;

    var h:Int;
    if (height == 0)
      h = Std.int(tf.height) + marginTop + marginBottom;
    else
      h = height;

    if (bitmap == null || bitmap.width != w || bitmap.height != h) {
      bitmap = new BitmapData(w, h, true, bgcolor);
    } else
      bitmap.fillRect(new Rectangle(0, 0, bitmap.width, bitmap.height), bgcolor);

    if (predecorator != null)
      predecorator(bitmap);

    var matrix:Matrix = new Matrix();
    matrix.translate(marginLeft, marginTop);
    if (format.align == TextFormatAlign.CENTER) {
      matrix.translate((w-tf.width)/2, 0);
    } else if (format.align == TextFormatAlign.RIGHT) {
      matrix.translate(w-tf.width, 0);
    }
    bitmap.draw(tf, matrix);

    if (postdecorator != null)
      postdecorator(bitmap);

    // end draw
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  /*
   * Note that the background color is necessarily a 32 bit integer.
   */

  public static function makeBitmap(string:String,
                                    opts:Dynamic=null,
                                    predecorator:BitmapData->Void=null,
                                    postdecorator:BitmapData->Void=null):Bitmap
  {
    var b:Bitmap = new Bitmap(makeBitmapData
                              (string, opts, predecorator, postdecorator));

    if (opts != null && Reflect.hasField(opts, "alpha")) {
      var d:Dynamic = Reflect.field(opts, "alpha");
      b.alpha = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    return b;
    // end bitmapData
  }

  public static function makeBitmapData
    (string:String,
     opts:Dynamic=null,
     predecorator:BitmapData->Void=null,
     postdecorator:BitmapData->Void=null):BitmapData
  {
    return new TextBitmap(string, opts, predecorator, postdecorator).bitmap;
    // end bitmapData
  }

  // end class TextBitmap
}
