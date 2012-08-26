/*
 * Copyright (c) 2012 Joe Kopena <tjkopena@gmail.com>
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

package com.rocketshipgames.haxe.gfx;

import nme.geom.Rectangle;
import nme.geom.Point;

import nme.display.BitmapData;
import nme.display.Tilesheet;

import GameSprite.GameSpriteAnimation;

class GameSpriteContainer
  extends Tilesheet,
  implements com.rocketshipgames.haxe.gfx.GraphicsContainer
{

  public var instanceCount:Int;

  //------------------------------------------------------------
  private var layers:Array<GameSpriteInstanceList>;

  private var blitData:Array<Float>;

  private var spriteData:Hash<GameSprite>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(spritesheet:BitmapData, descriptor:String):Void
  {
    if (spritesheet == null) {
      trace("GameSpriteContainer must be given spritesheet BitmapData.");
      return;
    }

    if (descriptor == null) {
      trace("GameSpriteContainer must be given spritesheet XML description.");
      return;
    }

    super(spritesheet);

    layers = new Array();
    layers[0] = new GameSpriteInstanceList();
    instanceCount = 0;

    blitData = new Array();

    //--------------------------------------------------
    //-- Parse the spritesheet XML
    spriteData = new Hash();
    var baseIndex:Int = 0;
    var index:Int = 0;

    var root = new haxe.xml.Fast(Xml.parse(descriptor).firstElement());
    for (sprite in root.nodes.sprite) {
      var data:GameSprite =
        new GameSprite(sprite.att.name,
                           index = baseIndex,
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

          /*
          trace("  Found " + rows + "x" + columns + " grid at " +
                basex + "," + basey + " -- " + width + "," + height);
          */

          var cx:Float = width/2;
          var cy:Float = height/2;
          var x:Int;
          var y:Int = basey;
          for (r in 0...rows) {
            x = basex;

            for (c in 0...columns) {
              addTileRect(new Rectangle(x, y, width, height),
                          new Point(cx, cy));
              /*
              trace("    Added " + index + "  " + x + "," + y + " -- " +
                    width + "," + height +
                    " [" + cx + "," + cy + "]");
              */

              index++;
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
          addTileRect(new Rectangle(x, y, width, height),
                      new Point(cx, cy));
          /*
          trace("    Added " + index + "[" + label +"]  " + x + "," + y +
                " -- " + width + "," + height +
                " [" + cx + "," + cy + "]");
          */

          if (label != null)
            data.setKeyframe(label, index);

          index++;

          // end frame command
        } else if (cmd.name == 'keyframe') {

          var label:String = cmd.att.label;
          var indice:Int = Std.parseInt(cmd.att.indice);

          data.setKeyframe(label, baseIndex+indice);

          /*
          trace("  Keyframe " + label + " -> " + indice +
                " ("+ (baseIndex+indice) +")");
          */

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

          /*
          trace("    Animation " + anim.name + " " +
                anim.numFrames() + " frames");
          */

          // end animation command
        }

        // end looping sprite commands
      }

      data.numFrames = index - baseIndex;
      // trace("  Total " + data.numFrames + " frames");

      baseIndex = index;
      // end looping sprite declarations
    }

    // end new
  }

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
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
  public function render(graphics:nme.display.Graphics, elapsed:Int):Void
  {
    var index:Int = 0;
    var s:GameSpriteInstance;

    for (l in layers) {

      // The list is drawn in reverse order so that newer entities,
      // namely bullets, are drawn under older entities.
      s = l.tail;
      while (s != null) {

        s.spriteUpdate(elapsed);

        if (s.isVisible()) {
          if (index >= blitData.length) {
            blitData.push(s.getX());
            blitData.push(s.getY());
            blitData.push(s.getFrame());
          } else {
            blitData[index] = s.getX();
            blitData[index+1] = s.getY();
            blitData[index+2] = s.getFrame();
          }
          index += 3;
        }

        s = s.prevGameSpriteInstance;
        // end looping sprites
      }
      // end looping layers
    }

    if (index < blitData.length) {
      blitData.splice(index, blitData.length-index);
    }

    drawTiles(graphics, blitData);
    // end render
  }

  // end GameSpriteContainer
}
