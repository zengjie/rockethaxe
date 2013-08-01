package com.rocketshipgames.haxe.ui;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import com.rocketshipgames.haxe.gfx.flags.GrowthDirection;

import com.rocketshipgames.haxe.ui.Widget;


class WidgetList
  extends Sprite
  implements Widget
{

  //------------------------------------------------------------
  private var widgets:List<Widget>;

  private var growth:GrowthDirection;

  private var baseX:Float;
  private var baseY:Float;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(x:Float, y:Float,
                      ?container:DisplayObjectContainer,
                      ?opts:Dynamic):Void
  {
    super();

    this.x = baseX = x;
    this.y = baseY = y;

    growth = FORWARD;

    widgets = new List();

    if (opts != null) {
      var d:Dynamic;

      if ((d = Reflect.field(opts, "direction")) != null) {
        if (Std.is(d, GrowthDirection))
          growth = d;
        else
          growth = Type.createEnum(GrowthDirection, d);
      }
    }

    visible = false;
    if (container != null)
      container.addChild(this);

    // end new
  }

  public function setContainer(container:DisplayObjectContainer):Void
  {
    if (parent != null)
      parent.removeChild(this);
    container.addChild(this);
    // end setContainer
  }

  public function remove():Void
  {
    if (parent != null)
      parent.removeChild(this);
    // end remove
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  //------------------------------------------------------------
  public function getX():Float { return x; }
  public function getY():Float { return y; }

  public function setX(x:Float):Float { return this.x = x; }
  public function setY(y:Float):Float { return this.y = y; }

  public function getWidth():Float { return width; }
  public function getHeight():Float { return height; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function show(?opts:Dynamic):Void
  {
    visible = true;
    // end show
  }

  public function hide(?opts:Dynamic):Void
  {
    visible = false;
    // end hide
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function add(widget:Widget):Void
  {

    switch (growth) {
    case FORWARD:
      widgets.add(widget);

    case REVERSE:
      widgets.push(widget);
    }

    widget.setContainer(this);

    widget.show();

    // end add
  }

  // end WidgetList
}
