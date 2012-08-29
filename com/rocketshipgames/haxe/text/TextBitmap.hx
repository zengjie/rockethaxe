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

  private var paddingLeft:Int;
  private var paddingRight:Int;
  private var paddingTop:Int;
  private var paddingBottom:Int;

  private var borderLeftWidth:Int;
  private var borderLeftColor:Int;
  private var borderRightWidth:Int;
  private var borderRightColor:Int;
  private var borderTopWidth:Int;
  private var borderTopColor:Int;
  private var borderBottomWidth:Int;
  private var borderBottomColor:Int;

  private var predecorator:BitmapData->Void;
  private var postdecorator:BitmapData->Void;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(string:String,
                      ?opts:Dynamic=null):Void
  {
    tf = new TextField();

    size = defaultSize;
    color = defaultColor;
    bgcolor = defaultBackgroundColor;

    width = 0;
    height = 0;

    paddingLeft = paddingRight = paddingTop = paddingBottom = 0;

    borderLeftWidth = borderRightWidth = borderTopWidth = borderBottomWidth = 0;
    borderLeftColor = borderRightColor = borderTopColor = borderBottomColor =
      0xffffffff;

    predecorator = postdecorator = null;

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
      var d:Dynamic;

      if ((d = Reflect.field(opts, "size")) != null) {
        size = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "color")) != null) {
        color = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      borderLeftColor = borderRightColor = borderTopColor = borderBottomColor =
        color;

      /*
       * Note that the background color is necessarily a 32 bit integer.
       */
      if ((d = Reflect.field(opts, "bgcolor")) != null) {
        bgcolor = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }


      if ((d = Reflect.field(opts, "padding")) != null) {
        paddingLeft = paddingRight = paddingTop = paddingBottom =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "paddingLeft")) != null) {
        paddingLeft = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "paddingRight")) != null) {
        paddingRight = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "paddingTop")) != null) {
        paddingTop = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "paddingBottom")) != null) {
        paddingBottom = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }


      if ((d = Reflect.field(opts, "width")) != null) {
        width = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "height")) != null) {
        height = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }


      if ((d = Reflect.field(opts, "borderWidth")) != null) {
        borderLeftWidth = borderRightWidth = borderTopWidth = borderBottomWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderColor")) != null) {
        borderLeftColor = borderRightColor = borderTopColor = borderBottomColor =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "borderLeftWidth")) != null) {
        borderLeftWidth = borderRightWidth = borderTopWidth = borderBottomWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderLeftColor")) != null) {
        borderLeftColor = borderRightColor = borderTopColor = borderBottomColor =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "borderRightWidth")) != null) {
        borderRightWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderRightColor")) != null) {
        borderRightColor =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "borderTopWidth")) != null) {
        borderTopWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderTopColor")) != null) {
        borderTopColor =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "borderBottomWidth")) != null) {
        borderBottomWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderBottomColor")) != null) {
        borderBottomColor =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }


      // Note that you can't just set these because you don't want to
      // override a previous decorator if the new opts don't have one.
      if ((d = Reflect.field(opts, "predecorator")) != null) {
        predecorator = d;
      }
      if ((d = Reflect.field(opts, "postdecorator")) != null) {
        postdecorator = d;
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
      w = Std.int(tf.width) +
        paddingLeft + paddingRight +
        borderLeftWidth + borderRightWidth;
    else
      w = width;

    var h:Int;
    if (height == 0)
      h = Std.int(tf.height) +
        paddingTop + paddingBottom +
        borderTopWidth + borderBottomWidth;
    else
      h = height;

    if (bitmap == null || bitmap.width != w || bitmap.height != h) {
      bitmap = new BitmapData(w, h, true, bgcolor);
    } else
      bitmap.fillRect(new Rectangle(0, 0, bitmap.width, bitmap.height), bgcolor);


    //-- Predecorate---fill in any background, etc
    if (predecorator != null)
      predecorator(bitmap);

    //-- Draw any defined borders
    if (borderLeftWidth != 0) {
      bitmap.fillRect(new Rectangle(0, 0,
                                    borderLeftWidth, bitmap.height),
                                    borderLeftColor);
    }

    if (borderRightWidth != 0) {
      bitmap.fillRect(new Rectangle(bitmap.width-borderRightWidth, 0,
                                    borderRightWidth, bitmap.height),
                                    borderRightColor);
    }

    if (borderTopWidth != 0) {
      bitmap.fillRect(new Rectangle(0, 0,
                                    bitmap.width, borderTopWidth),
                                    borderTopColor);
    }

    if (borderBottomWidth != 0) {
      bitmap.fillRect(new Rectangle(0, bitmap.height-borderBottomWidth,
                                    bitmap.width, borderBottomWidth),
                                    borderBottomColor);
    }

    //-- Actually draw the text
    var matrix:Matrix = new Matrix();
    if (format.align == TextFormatAlign.CENTER) {
      matrix.translate((w-tf.width)/2, paddingTop+borderTopWidth);
    } else if (format.align == TextFormatAlign.RIGHT) {
      matrix.translate(w-(tf.width+paddingRight+borderRightWidth),
                       paddingTop+borderTopWidth);
    } else {
      matrix.translate(paddingLeft+borderLeftWidth,
                       paddingTop+borderTopWidth);
    }
    bitmap.draw(tf, matrix);

    //-- Postdecorator---apply filters, etc
    if (postdecorator != null)
      postdecorator(bitmap);

    // end draw
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function makeBitmap(string:String,
                                    ?opts:Dynamic):Bitmap
  {
    var b:Bitmap = new Bitmap(makeBitmapData(string, opts));

    if (opts != null && Reflect.hasField(opts, "alpha")) {
      var d:Dynamic = Reflect.field(opts, "alpha");
      b.alpha = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    return b;
    // end bitmapData
  }

  public static function makeBitmapData(string:String,
                                        ?opts:Dynamic):BitmapData
  {
    return new TextBitmap(string, opts).bitmap;
    // end bitmapData
  }

  // end class TextBitmap
}
