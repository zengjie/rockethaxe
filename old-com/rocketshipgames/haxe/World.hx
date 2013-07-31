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

package com.rocketshipgames.haxe;

interface World
  implements TimerContainer
{

  var worldWidth(default,null):Float;
  var worldHeight(default,null):Float;

  var displayWidth(default,null):Int;
  var displayHeight(default,null):Int;

  var time(default,null):Int;
  var elapsed(default,null):Int;


  public function addEntity(e:Entity):Entity;
  public function removeEntity(e:Entity):Void;

  public function addSignal(id:String, signal:Signal):Signal;
  public function removeSignal(id:String, signal:Signal):Void;
  public function signal(id:String, msg:Dynamic):Void;

  public function addState(id:String, state:State):State;
  public function removeState(id:String):Void;
  public function getState(id:String):State;
  public function getStateValue(id:String):Dynamic;

  // end World
}
