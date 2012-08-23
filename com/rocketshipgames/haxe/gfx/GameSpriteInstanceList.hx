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

class GameSpriteInstanceList
{
  public var head:GameSpriteInstance;
  public var tail:GameSpriteInstance;

  public function new():Void
  {
    head = null;
    tail = null;
    // end new
  }

  public function add(i:GameSpriteInstance):Void
  {
    if (i.prevGameSpriteInstance != null || i.nextGameSpriteInstance != null) {
      trace("GameSpriteInstance already in container.");
      return;
    }

    if (tail == null)
      head = i;
    else
      tail.nextGameSpriteInstance = i;

    i.prevGameSpriteInstance = tail;
    tail = i;
    i.nextGameSpriteInstance = null;

    // end add
  }

  public function remove(i:GameSpriteInstance):Void
  {

    if ((i.prevGameSpriteInstance == null && head != i) ||
        (i.nextGameSpriteInstance == null && tail != i)) {
      trace("GamespriteInstance not in container.");
      return;
    }

    if (i.prevGameSpriteInstance != null)
      i.prevGameSpriteInstance.nextGameSpriteInstance =
        i.nextGameSpriteInstance;
    else
      head = i.nextGameSpriteInstance;

    if (i.nextGameSpriteInstance != null)
      i.nextGameSpriteInstance.prevGameSpriteInstance =
        i.prevGameSpriteInstance;
    else
      tail = i.prevGameSpriteInstance;

    i.nextGameSpriteInstance = i.prevGameSpriteInstance = null;

    // end remove
  }

  // end GameSpriteInstanceList
}
