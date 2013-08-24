package com.rocketshipgames.haxe.gfx.displaylist;

import flash.display.Sprite;
import flash.display.DisplayObject;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.Entity;


class DisplayListGraphicsContainer
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer
{

  private var root:Sprite;

  private var graphicsList:DoubleLinkedList<DisplayListGraphicComponent>;


  public function new(root:Sprite):Void
  {
    this.root = root;

    graphicsList = new DoubleLinkedList();
    // end new
  }


  //--------------------------------------------------------------------
  public function render(graphics:flash.display.Graphics):Void
  {
    for (g in graphicsList)
      g.render();
    // end render
  }


  //--------------------------------------------------------------------
  public function addDisplayListGraphic(entity:Entity, graphic:DisplayObject):Void
  {
    var gc = new DisplayListGraphicComponent(root, graphic);
    entity.addComponent(gc);
    graphicsList.add(gc);
  }

  // end DisplayListGraphicsContainer
}
