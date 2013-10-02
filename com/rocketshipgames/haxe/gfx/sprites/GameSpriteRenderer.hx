package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;

import com.rocketshipgames.haxe.component.ComponentContainer;
import com.rocketshipgames.haxe.component.CapabilityID;


class GameSpriteRenderer
  implements SpritesheetRenderer
{

  //------------------------------------------------------------
  @:allow(com.rocketshipgames.haxe.gfx.sprites.GameSpriteComponent)
  private var container:SpritesheetContainer;

  private var layers:Array<DoubleLinkedList<GameSpriteComponent>>;

  private var count:Int;

  private var tag:CapabilityID;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(?tag:CapabilityID):Void
  {

    layers = new Array();
    count = 0;

    if (tag != null)
      this.tag = tag;
    else
      this.tag = GameSpriteComponent.CID;

    // end new
  }

  public function attach(container:SpritesheetContainer):Void
  {
    this.container = container;
    // end attach
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function getCount():Int
  {
    return count;
    // end getCount
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function add(entity:ComponentContainer, layer:Int=0):Void
  {
    var gc = cast(entity.find(tag), GameSpriteComponent);
    addComponent(gc, layer);
    // end add
  }

  public function remove(entity:ComponentContainer):Void
  {
    var gc = cast(entity.find(tag), GameSpriteComponent);
    removeComponent(gc);
    // end remove
  }

  public function relayer(entity:ComponentContainer, layer:Int=0):Void
  {
    var gc = cast(entity.find(tag), GameSpriteComponent);
    relayerComponent(gc, layer);
    // end relayer
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function addComponent(sprite:GameSpriteComponent, layer:Int=0):Void
  {
    sprite.layer = layer;

    while (layers.length <= layer)
      layers.push(new DoubleLinkedList<GameSpriteComponent>());

    sprite.setRenderer(this);
    sprite.handle = layers[layer].add(sprite);
    count++;
    // end addComponent
  }

  public function removeComponent(sprite:GameSpriteComponent)
  {
    sprite.handle.remove();
    count--;
    // end removeComponent
  }

  public function relayerComponent(sprite:GameSpriteComponent, layer:Int=0)
  {
    removeComponent(sprite);
    addComponent(sprite, layer);
    // end relayerComponent
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(viewport:com.rocketshipgames.haxe.gfx.Viewport):Void
  {

    var ptr:DoubleLinkedListHandle<GameSpriteComponent>;

    for (layer in layers) {

      // The list is drawn in reverse order so that newer entities,
      // namely bullets, are drawn under older entities.
      ptr = layer.tail;
      while (ptr != null) {
        ptr.item.render(viewport);
        ptr = ptr.prev;
        // end looping sprites
      }
      // end looping layers
    }

    // end render
  }

  // end GameSpriteRenderer
}
