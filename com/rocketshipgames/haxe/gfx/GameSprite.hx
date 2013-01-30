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

import com.rocketshipgames.haxe.debug.Debug;

class GameSpriteAnimationFrame {
  public var frame:Int;
  public var interval:Int;

  public function new(frame:Int, interval:Int):Void
  {
    this.frame = frame;
    this.interval = interval;
    // end new
  }

  // end GameSpriteAnimationFrame
}


class GameSpriteAnimation {

  public static var DEFAULT_INTERVAL:Int = 100;

  public var name:String;
  public var loop:Bool;

  //------------------------------------------------------------
  private var sequence:List<GameSpriteAnimationFrame>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(name:String):Void
  {
    this.name = name;
    loop = false;
    sequence = new List();
  }

  public function numFrames():Int { return sequence.length; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function addFrame(frame:Int, interval:Int):Void
  {
    sequence.add(new GameSpriteAnimationFrame(frame, interval));
    // end addFrame
  }

  //------------------------------------------------------------
  public function iterator():Iterator<GameSpriteAnimationFrame>
  {
    return sequence.iterator();
  }

  // end GameSpriteAnimation
}


class GameSprite {

  public var name:String;
  public var baseIndex:Int;
  public var numFrames:Int;

  public var width:Int;
  public var height:Int;

  //------------------------------------------------------------
  private var keyframes:Hash<Int>;
  private var animations:Hash<GameSpriteAnimation>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(name:String, width:Int, height:Int):Void
  {
    this.name = name;
    this.baseIndex = -1;
    this.width = width;
    this.height = height;

    keyframes = new Hash();
    animations = new Hash();

    numFrames = 0;
  }

  //------------------------------------------------------------
  public function addFrame(frame:Int):Void
  {

    // Don't actually need to track the frames

    numFrames++;

    if (baseIndex == -1)
      baseIndex = frame;

    // end addFrame
  }

  //------------------------------------------------------------
  public function hasAnimation(label:String):Bool
  {
    return animations.exists(label);
    // end hasAnimation
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function setKeyframe(label:String, index:Int):Void
  {
    keyframes.set(label, index);
  }

  public function keyframe(label:String):Int
  {
    if (!keyframes.exists(label)) {
      Debug.error("Unknown keyframe " + label + " in " + name);
      return baseIndex;
    }
    return keyframes.get(label);
    // end keyframe
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function setAnimation(label:String,
                               animation:GameSpriteAnimation):Void
  {
    animations.set(label, animation);
    // end setAnimation
  }

  public function animation(label:String):GameSpriteAnimation
  {
    if (!animations.exists(label)) {
      Debug.error("Unknown animation " + label + " in " + name);
      return null;
    }
    return animations.get(label);
    // end animation
  }

  // end GameSprite
}
