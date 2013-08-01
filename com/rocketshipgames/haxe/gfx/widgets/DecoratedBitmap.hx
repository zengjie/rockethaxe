package com.rocketshipgames.haxe.gfx.widgets;

import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;

import flash.display.Bitmap;
import flash.display.BitmapData;

import com.rocketshipgames.haxe.gfx.flags.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.flags.VerticalAlignment;


class DecoratedBitmap {

  public static var defaultBackgroundColor:Int = 0x00000000;

  //------------------------------------------------------------
  public var bitmap:BitmapData = null;

  //------------------------------------------------------------
  private var bgcolor:Int;

  private var alphaMultiplier:Float;
  private var redMultiplier:Float;
  private var greenMultiplier:Float;
  private var blueMultiplier:Float;

  private var underline:Bool;

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

  private var horizontalJustification:HorizontalAlignment;
  private var verticalJustification:VerticalAlignment;

  private var predecorator:BitmapData->Void;
  private var postdecorator:BitmapData->Void;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(source:BitmapData,
                      ?opts:Dynamic=null):Void
  {
    bgcolor = defaultBackgroundColor;

    alphaMultiplier = redMultiplier = greenMultiplier = blueMultiplier = 1;

    width = 0;
    height = 0;

    paddingLeft = paddingRight = paddingTop = paddingBottom = 0;

    borderLeftWidth = borderRightWidth = borderTopWidth = borderBottomWidth = 0;
    borderLeftColor = borderRightColor = borderTopColor = borderBottomColor =
      0xffffffff;

    horizontalJustification = HorizontalAlignment.CENTER;
    verticalJustification = VerticalAlignment.MIDDLE;

    predecorator = postdecorator = null;

    if (opts != null) {
      var d:Dynamic;

      /*
       * Note that the background color is necessarily a 32 bit integer.
       */
      if ((d = Reflect.field(opts, "bgcolor")) != null) {
        bgcolor = (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "alphaMultiplier")) != null) {
        alphaMultiplier = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }
      if ((d = Reflect.field(opts, "redMultiplier")) != null) {
        redMultiplier = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }
      if ((d = Reflect.field(opts, "greenMultiplier")) != null) {
        greenMultiplier = (Std.is(d, String)) ? Std.parseFloat(d) : d;
      }
      if ((d = Reflect.field(opts, "blueMultiplier")) != null) {
        blueMultiplier = (Std.is(d, String)) ? Std.parseFloat(d) : d;
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
        borderLeftWidth = borderRightWidth =
          borderTopWidth = borderBottomWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderColor")) != null) {
        borderLeftColor = borderRightColor =
          borderTopColor = borderBottomColor =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }

      if ((d = Reflect.field(opts, "borderLeftWidth")) != null) {
        borderLeftWidth = borderRightWidth =
          borderTopWidth = borderBottomWidth =
          (Std.is(d, String)) ? Std.parseInt(d) : d;
      }
      if ((d = Reflect.field(opts, "borderLeftColor")) != null) {
        borderLeftColor = borderRightColor =
          borderTopColor = borderBottomColor =
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

      if ((d = Reflect.field(opts, "horizontalJustification")) != null) {
        horizontalJustification = d;
      }
      if ((d = Reflect.field(opts, "verticalJustification")) != null) {
        verticalJustification = d;
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

    draw(source);

    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function draw(source:BitmapData):Void
  {

    var w:Int;
    if (width == 0)
      w = Std.int(source.width) +
        paddingLeft + paddingRight +
        borderLeftWidth + borderRightWidth;
    else
      w = width;

    var h:Int;
    if (height == 0)
      h = Std.int(source.height) +
        paddingTop + paddingBottom +
        borderTopWidth + borderBottomWidth;
    else
      h = height;

    if (bitmap == null || bitmap.width != w || bitmap.height != h) {
      bitmap = new BitmapData(w, h, true, bgcolor);
    } else
      bitmap.fillRect(new Rectangle(0, 0, bitmap.width, bitmap.height),
                      bgcolor);


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

    //-- Actually draw the source
    var x:Float;
    var y:Float;

    switch (horizontalJustification) {
    case LEFT:
      x = 0;

    case CENTER:
      x = (bitmap.width - source.width)/2;

    case RIGHT:
      x = bitmap.width - source.width;
    }

    switch (verticalJustification) {
    case TOP:
      y = 0;

    case MIDDLE:
      y = (bitmap.height - source.height)/2;

    case BOTTOM:
      y = bitmap.height - source.height;
    }

    // Drawn this way instead of using copyPixels() in order to not
    // overwrite decorated image with transparent pixels.
    var matrix:Matrix = new Matrix();
    matrix.translate(x, y);

    var trans:ColorTransform = new ColorTransform();
    trans.alphaMultiplier = alphaMultiplier;
    trans.redMultiplier = redMultiplier;
    trans.greenMultiplier = greenMultiplier;
    trans.blueMultiplier = blueMultiplier;

    bitmap.draw(source, matrix, trans);

    //-- Postdecorator---apply filters, etc
    if (postdecorator != null)
      postdecorator(bitmap);

    // end draw
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function makeBitmap(source:BitmapData,
                                    ?opts:Dynamic):Bitmap
  {
    var b:Bitmap = new Bitmap(makeBitmapData(source, opts));

    if (opts != null && Reflect.hasField(opts, "alpha")) {
      var d:Dynamic = Reflect.field(opts, "alpha");
      b.alpha = (Std.is(d, String)) ? Std.parseInt(d) : d;
    }

    return b;
    // end bitmapData
  }

  public static function makeBitmapData(source:BitmapData,
                                        ?opts:Dynamic):BitmapData
  {
    return new DecoratedBitmap(source, opts).bitmap;
    // end bitmapData
  }

  // end class DecoratedBitmap
}
