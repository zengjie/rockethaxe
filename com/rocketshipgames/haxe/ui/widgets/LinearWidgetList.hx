package com.rocketshipgames.haxe.ui.widgets;

import flash.display.DisplayObjectContainer;

import com.rocketshipgames.haxe.gfx.flags.Orientation;
import com.rocketshipgames.haxe.gfx.flags.HorizontalAlignment;
import com.rocketshipgames.haxe.gfx.flags.VerticalAlignment;

import com.rocketshipgames.haxe.ui.Widget;
import com.rocketshipgames.haxe.ui.WidgetList;


class LinearWidgetList
  extends WidgetList
{

  //------------------------------------------------------------
  private var orientation:Orientation;

  private var horizontalAlignment:HorizontalAlignment;
  private var verticalAlignment:VerticalAlignment;

  private var horizontalJustification:HorizontalAlignment;
  private var verticalJustification:VerticalAlignment;

  private var margin:Float;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(x:Float, y:Float,
                      ?container:DisplayObjectContainer,
                      ?opts:Dynamic):Void
  {
    super(x, y, container, opts);

    orientation = HORIZONTAL;
    horizontalAlignment = LEFT;
    verticalAlignment = TOP;

    horizontalJustification = LEFT;
    verticalJustification = TOP;

    margin = 0;

    if (opts != null) {
      var d:Dynamic;

      if ((d = Reflect.field(opts, "orientation")) != null) {
        if (Std.is(d, Orientation))
          orientation = d;
        else
          orientation = Type.createEnum(Orientation, d);
      }

      if ((d = Reflect.field(opts, "horizontalAlignment")) != null) {
        if (Std.is(d, HorizontalAlignment))
          horizontalAlignment = d;
        else
          horizontalAlignment = Type.createEnum(HorizontalAlignment, d);
      }

      if ((d = Reflect.field(opts, "verticalAlignment")) != null) {
        if (Std.is(d, VerticalAlignment))
          verticalAlignment = d;
        else
          verticalAlignment = Type.createEnum(VerticalAlignment, d);
      }

      if ((d = Reflect.field(opts, "horizontalJustification")) != null) {
        if (Std.is(d, HorizontalAlignment))
          horizontalJustification = d;
        else
          horizontalJustification = Type.createEnum(HorizontalAlignment, d);
      }

      if ((d = Reflect.field(opts, "verticalJustification")) != null) {
        if (Std.is(d, VerticalAlignment))
          verticalJustification = d;
        else
          verticalJustification = Type.createEnum(VerticalAlignment, d);
      }

      if ((d = Reflect.field(opts, "margin")) != null) {
        if (Std.is(d, Float))
          margin = d;
        else
          margin = Std.parseFloat(d);
      }

      // opts is not null
    }

    // end new
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public override function add(widget:Widget):Void
  {
    super.add(widget);
    pack();
    // end add
  }

  //------------------------------------------------------------
  public function pack():Void
  {
    var subWidth:Float;
    var subHeight:Float;

    switch (orientation) {
    case HORIZONTAL:

      subWidth = -margin;
      subHeight = 0;
      for (w in widgets) {
        subWidth += w.getWidth() + margin;
        subHeight = Math.max(w.getHeight(), subHeight);
      }

      var tx:Float = 0;
      for (w in widgets) {
        switch (verticalJustification) {
        case TOP:
          w.setY(0);

        case MIDDLE:
          w.setY((subHeight-w.getHeight())/2);

        case BOTTOM:
          w.setY(subHeight-w.getHeight());

          // end vertical alignment
        }

        w.setX(tx);
        tx += w.getWidth() + margin;

      }


    case VERTICAL:

      subWidth = 0;
      subHeight = -margin;
      for (w in widgets) {
        subWidth = Math.max(w.getWidth(), subWidth);
        subHeight += w.getHeight() + margin;
      }

      var ty:Float = 0;
      for (w in widgets) {

        switch (horizontalJustification) {
        case LEFT:
          w.setX(0);

        case CENTER:
          w.setX((subWidth-w.getWidth())/2);

        case RIGHT:
          w.setX(subWidth-w.getWidth());
        }

        w.setY(ty);
        ty += w.getHeight() + margin;
      }

      // end switch orientation
    }

    switch (horizontalAlignment) {
    case LEFT:
      x = baseX;

    case CENTER:
      x = baseX - subWidth/2;

    case RIGHT:
      x = baseX - subWidth;

      // end horizontal alignment
    }

    switch (verticalAlignment) {
    case TOP:
      y = baseY;

    case MIDDLE:
      y = baseY - subHeight/2;

    case BOTTOM:
      y = baseY - subHeight;

      // end vertical alignment
    }

    // end pack
  }

  // end LinearWidgetList
}
