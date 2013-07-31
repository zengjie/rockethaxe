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

import GameSprite.GameSpriteAnimation;
import GameSprite.GameSpriteAnimationFrame;

class GameSpriteInstance {

  public var x:Float;
  public var y:Float;

  public var frame:Int;

  public var layer:Int;

  public var visible:Bool = true;

  public var animating:Bool = false;
  public var animationClock:Int = 0;
  public var animation:GameSpriteAnimation = null;
  public var animationCursor:Iterator<GameSpriteAnimationFrame>;
  public var loopAnimation:Bool = false;
  public var onAnimationComplete:Void -> Void = null;

  public var sprite:GameSprite = null;

  public var nextGameSpriteInstance:GameSpriteInstance;
  public var prevGameSpriteInstance:GameSpriteInstance;

  public var gfxContainer:GameSpriteContainer;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(gfxContainer:GameSpriteContainer,
                      layer:Int = 0,
                      sprite:GameSprite = null,
                      name:String = null,
                      label:String = null,
                      enable:Bool = true) {

    this.gfxContainer = gfxContainer;
    this.layer = layer;

    if (sprite != null) {

      this.sprite = sprite;

      // was given sprite
    } else if (name != null) {
      this.sprite = this.gfxContainer.getSprite(name);
    }

    if (this.sprite != null) {
      if (label != null) {

        // Don't just utilize null result from sprite.animation() here
        // as it'll trigger a trace message on the failed hit.
        if (this.sprite.hasAnimation(label))
          play(this.sprite.animation(label));
        else
          frame = this.sprite.keyframe(label);

      } else {
        frame = this.sprite.baseIndex;
      }

      // end acquired a sprite
    }

    x = 0;
    y = 0;

    if (enable)
      gfxContainer.addInstance(this, layer);

    // end new
  }

  private var chain:GameSpriteInstance = null;

  public function chainTo(anchor:GameSpriteInstance, x:Float=0, y:Float=0):Void
  {
    chain = anchor;
    this.x = x;
    this.y = y;
    // end chainTo
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function enableSprite():Void
  {
    gfxContainer.addInstance(this, layer);
    // end enableSprite
  }

  public function disableSprite():Void
  {
    gfxContainer.removeInstance(this);
    // end disableSprite
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function isVisible():Bool { return visible; }

  public function getX():Float { return (chain == null) ? x : (chain.x + x); }

  public function getY():Float { return (chain == null) ? y : (chain.y + y); }

  public function getFrame():Int { return frame; }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function spriteUpdate(elapsed):Void
  {

    if (animating) {
      animationClock -= elapsed;
      if (animationClock <= 0) {
        if (animationCursor.hasNext()) {
          var f:GameSpriteAnimationFrame = animationCursor.next();
          frame = f.frame;
          animationClock = f.interval;
        } else {
          if (onAnimationComplete != null)
            onAnimationComplete();

          // This is after onAnimationComplete so you could disable
          // the looping based on some immediate condition.

          if (loopAnimation)
            resetAnimation();
          else
            animating = false;

          // end hit end of animation
        }
      }
      // end animating
    }

    // end spriteUpdate
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function play(animation:GameSpriteAnimation,
                       onAnimationComplete:Void->Void = null,
                       forceLoop:Bool = false,
                       loopAnimation:Bool = true,
                       forceReset:Bool = false):Void
  {

    // This business with an iterator rather than manually indexing
    // into the sequence is done because it's presumably faster
    // traversing a List this way than the slow Array implementation
    // on some platforms.

    if (animating && this.animation == animation && !forceReset)
      return;

    animating = true;
    this.animation = animation;
    this.onAnimationComplete = onAnimationComplete;
    if (forceLoop) {
      this.loopAnimation = loopAnimation;
    } else {
      this.loopAnimation = this.animation.loop;
    }

    resetAnimation();

    // end play
  }

  public function stop(complete:Bool = false)
  {

    animating = false;
    this.animation = null;

    if (onAnimationComplete != null && complete)
      onAnimationComplete();

    // end stop
  }

  public function pause()
  {
    animating = false;
    // end stop
  }

  public function resume()
  {
    animating = true;
    // end resume
  }

  //------------------------------------------------------------
  private function resetAnimation()
  {
    animationCursor = animation.iterator();
    var f:GameSpriteAnimationFrame = animationCursor.next();
    frame = f.frame;
    animationClock = f.interval;
    // end resetAnimation
  }

  // end GameSpriteInstance
}
