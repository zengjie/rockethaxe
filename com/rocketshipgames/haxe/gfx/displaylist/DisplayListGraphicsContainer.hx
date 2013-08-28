package com.rocketshipgames.haxe.gfx.displaylist;

import flash.display.Sprite;
import flash.display.DisplayObject;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;

import com.rocketshipgames.haxe.gfx.Viewport;


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
  public function render(graphics:flash.display.Graphics, viewport:Viewport):Void
  {
    for (g in graphicsList)
      g.render(viewport);
    // end render
  }


  //--------------------------------------------------------------------
  public function addDisplayListGraphic(entity:ComponentContainer,
                                        graphic:DisplayObject):Void
  {
    var gc = new DisplayListGraphicComponent(root, graphic);
    entity.add(gc);
    graphicsList.add(gc);
  }

  // end DisplayListGraphicsContainer
}
