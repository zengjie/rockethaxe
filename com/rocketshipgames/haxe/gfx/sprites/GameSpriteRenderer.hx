package com.rocketshipgames.haxe.gfx.sprites;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;


class GameSpriteRenderer
  implements SpritesheetRenderer
{

  //------------------------------------------------------------
  private var layers:Array<DoubleLinkedList<GameSpriteInstance>>;

  private var spriteData:Hash<GameSprite>;

  private var container:SpritesheetContainer;

  private var instanceCount:Int;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(container:SpritesheetContainer,
                      descriptor:String = null):Void
  {

    if (container == null) {
      Debug.error("GameSpriteRenderer requires spritesheet container.");
      return;
    }

    this.container = container;
    container.addRenderer(this);

    spriteData = new Hash();

    layers = new Array();
    layers[0] = new GameSpriteInstanceList();
    instanceCount = 0;

    if (descriptor != null) {
      parseXML(descriptor);
    }

    // end new
  }

  public function attach(container:SpritesheetContainer):Void
  {
    this.container = container;
    // end attach
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function parseXML(descriptor:String):Void
  {
    var framePtr:Int;

    var root = new haxe.xml.Fast(Xml.parse(descriptor).firstElement());
    for (sprite in root.nodes.sprite) {
      var data:GameSprite =
        new GameSprite(sprite.att.name,
                       Std.parseInt(sprite.att.width),
                       Std.parseInt(sprite.att.height));
      spriteData.set(data.name, data);

      for (cmd in sprite.elements) {
        if (cmd.name == "grid") {

          var columns:Int = 1;
          var rows:Int = 1;
          if (cmd.has.columns) columns = Std.parseInt(cmd.att.columns);
          if (cmd.has.rows) rows = Std.parseInt(cmd.att.rows);

          var basex:Int = Std.parseInt(cmd.att.x);
          var basey:Int = Std.parseInt(cmd.att.y);

          var width:Int = data.width;
          var height:Int = data.height;
          if (cmd.has.framewidth) width = Std.parseInt(cmd.att.framewidth);
          if (cmd.has.frameheight) height = Std.parseInt(cmd.att.frameheight);

          var cx:Float = width/2;
          var cy:Float = height/2;
          var x:Int;
          var y:Int = basey;
          for (r in 0...rows) {
            x = basex;

            for (c in 0...columns) {
              framePtr = container.addSprite(x, y, width, height, cx, cy);
              data.addFrame(framePtr);
              x += width;
              // end columns
            }

            y += height;
            // end rows
          }

          // end grid command
        } else if (cmd.name == 'frame') {

          var label:String = null;
          if (cmd.has.label) label = cmd.att.label;

          var width:Int = data.width;
          var height:Int = data.height;
          if (cmd.has.framewidth) width = Std.parseInt(cmd.att.framewidth);
          if (cmd.has.frameheight) height = Std.parseInt(cmd.att.frameheight);

          var x:Int = Std.parseInt(cmd.att.x);
          var y:Int = Std.parseInt(cmd.att.y);
          var cx:Float = width/2;
          var cy:Float = height/2;

          framePtr = container.addSprite(x, y, width, height, cx, cy);
          data.addFrame(framePtr);

          if (label != null)
            data.setKeyframe(label, framePtr);

          // end frame command
        } else if (cmd.name == 'keyframe') {

          var label:String = cmd.att.label;
          var indice:Int = Std.parseInt(cmd.att.indice);

          data.setKeyframe(label, data.baseIndex+indice);


          // end keyframe command
        } else if (cmd.name == 'animation') {

          var label:String = cmd.att.label;

          var anim:GameSpriteAnimation = new GameSpriteAnimation(label);
          data.setAnimation(label, anim);

          if (cmd.has.loop && cmd.att.loop != 'false') {
            anim.loop = true;
          }

          for (animcmd in cmd.elements) {
            if (animcmd.name == 'sequence') {
              var start:String = animcmd.att.start;
              var end:String = animcmd.att.end;
              var startFrame:Int = data.keyframe(start);
              var endFrame:Int = data.keyframe(end);

              var interval:Int = GameSpriteAnimation.DEFAULT_INTERVAL;
              if (animcmd.has.interval)
                interval = Std.parseInt(animcmd.att.interval);

              var fm:Int = startFrame;
              while (fm <= endFrame) {
                anim.addFrame(fm, interval);
                fm++;
              }

              // end sequence
            } else if (animcmd.name == 'cell') {
              var label:String = animcmd.att.label;
              var fm:Int = data.keyframe(label);

              var interval:Int = GameSpriteAnimation.DEFAULT_INTERVAL;
              if (animcmd.has.interval)
                interval = Std.parseInt(animcmd.att.interval);

              anim.addFrame(fm, interval);
              // end cell
            }

            // end looping animation commands
          }

          // end animation command
        }

        // end looping sprite commands
      }

      // end looping sprite declarations
    }

    // end parseXML
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function getNumInstances():Int
  {
    return instanceCount;
    // end getNumInstances
  }

  //------------------------------------------------------------
  public function getSprite(name:String)
  {
    return spriteData.get(name);
    // end getSprite
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function addInstance(sprite:GameSpriteInstance, layer:Int=0):Void
  {
    sprite.layer = layer;

    while (layers.length <= layer) {
      layers.push(new GameSpriteInstanceList());
    }

    layers[layer].add(sprite);
    instanceCount++;
    // end addInstance
  }

  public function removeInstance(sprite:GameSpriteInstance)
  {
    if (sprite.layer >= 0 && sprite.layer < layers.length) {
      layers[sprite.layer].remove(sprite);
      instanceCount--;
    }
    // end function removeInstance
  }

  public function relayerInstance(sprite:GameSpriteInstance, layer:Int=0)
  {
    removeInstance(sprite);
    addInstance(sprite, layer);
    // end function relayerInstance
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function render(elapsed:Int):Void
  {

    var s:GameSpriteInstance;

    for (l in layers) {

      // The list is drawn in reverse order so that newer entities,
      // namely bullets, are drawn under older entities.
      s = l.tail;
      while (s != null) {

        s.spriteUpdate(elapsed);

        if (s.isVisible())
          container.drawSprite(s.getX(), s.getY(), s.getFrame());

        s = s.prevGameSpriteInstance;
        // end looping sprites
      }
      // end looping layers
    }

    // end render
  }

  // end GameSpriteRenderer
}
