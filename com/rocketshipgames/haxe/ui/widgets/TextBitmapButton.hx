package com.rocketshipgames.haxe.ui.widgets;

import flash.display.DisplayObjectContainer;

import com.rocketshipgames.haxe.gfx.text.TextBitmap;


class TextBitmapButton
  extends BitmapButton
{

  private var upText:TextBitmap;
  private var overText:TextBitmap;
  private var downText:TextBitmap;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(action:Void->Void,
                      text:String,
                      ?defaultStyle:Dynamic,
                      ?upStyle:Dynamic,
                      ?overStyle:Dynamic,
                      ?downStyle:Dynamic,
                      ?container:DisplayObjectContainer):Void
  {
    if (defaultStyle == null)
      defaultStyle = {};

    var _up = Reflect.copy(defaultStyle);
    if (upStyle != null) {
      for (f in Reflect.fields(upStyle))
        Reflect.setField(_up, f, Reflect.field(upStyle, f));
    }

    var _over = Reflect.copy(defaultStyle);
    if (overStyle != null) {
      for (f in Reflect.fields(overStyle))
        Reflect.setField(_over, f, Reflect.field(overStyle, f));
    }

    var _down = Reflect.copy(defaultStyle);
    if (downStyle != null) {
      for (f in Reflect.fields(downStyle))
        Reflect.setField(_down, f, Reflect.field(downStyle, f));
    }

    upText = new TextBitmap(text, _up);
    overText = new TextBitmap(text, _over);
    downText = new TextBitmap(text, _down);

    super(action, upText.bitmap, overText.bitmap, downText.bitmap, container);

    // end new
  }

  //--------------------------------------------------------------------
  public function setText(string:String):Void
  {
    upText.draw(string);
    overText.draw(string);
    downText.draw(string);

    upBitmap = upText.bitmap;
    overBitmap = overText.bitmap;
    downBitmap = downText.bitmap;

    generateDisabledBitmap();

    updateGraphicState();
    // end setText
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function populateList(widgetList:WidgetList,
                                      buttons:Array<Dynamic>,
                                      ?defaultStyle:Dynamic,
                                      ?upStyle:Dynamic,
                                      ?overStyle:Dynamic,
                                      ?downStyle:Dynamic,
                                      ?opts:Dynamic):Void
  {
    var dropTopBorder:Bool = true;

    if (opts != null) {
      var d:Dynamic;
      if ((d = Reflect.field(opts, "dropTopBorder")) != null)
        dropTopBorder = d;
    }

    var entry:Dynamic;
    entry = buttons.shift();
    if (entry != null) {
      widgetList.add(new TextBitmapButton
                     (entry.action, entry.text,
                      defaultStyle, upStyle, overStyle, downStyle));
    }

    if (dropTopBorder) {
      Reflect.setField(defaultStyle, "borderTopWidth", 0);
    }

    for (entry in buttons) {
      widgetList.add(new TextBitmapButton
                     (entry.action, entry.text,
                      defaultStyle, upStyle, overStyle, downStyle));
    }

    // end populateList
  }

  // end TextButton
}
