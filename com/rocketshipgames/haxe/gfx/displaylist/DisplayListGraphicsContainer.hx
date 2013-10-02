package com.rocketshipgames.haxe.gfx.displaylist;

import flash.display.Sprite;
import flash.display.DisplayObject;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.CapabilityID;

import com.rocketshipgames.haxe.gfx.Viewport;


class DisplayListGraphicsContainer
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer
{

  private var root:Sprite;

  private var graphicsList:DoubleLinkedList<DisplayListGraphicComponent>;

  private var tag:CapabilityID;


  public function new(root:Sprite,
                      ?tag:CapabilityID):Void
  {
    this.root = root;

    graphicsList = new DoubleLinkedList();

    if (tag != null)
      this.tag = tag;
    else
      this.tag = DisplayListGraphicComponent.CID;

    // end new
  }


  //--------------------------------------------------------------------
  public function render(graphics:flash.display.Graphics, viewport:Viewport):Void
  {
    for (g in graphicsList)
      g.render(viewport);
    // end render
  }


  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer):Void
  {
    var gc = cast(entity.find(tag), DisplayListGraphicComponent);
    gc.setRoot(root);
    graphicsList.add(gc);
  }

  // end DisplayListGraphicsContainer
}
