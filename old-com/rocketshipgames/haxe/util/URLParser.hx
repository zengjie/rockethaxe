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

/*
 * From http://haxe.org/doc/snip/uri_parser
 * Ported by Mike Cann to Haxe from JS source by Steve Levithan.
 */

package com.rocketshipgames.haxe.util;

class URLParser
{

  //------------------------------------------------------------
  public var url:String;
  public var source:String;
  public var protocol:String;
  public var authority:String;
  public var userInfo:String;
  public var user:String;
  public var password:String;
  public var host:String;
  public var port:String;
  public var relative:String;
  public var path:String;
  public var directory:String;
  public var file:String;
  public var query:String;
  public var anchor:String;
 
  //------------------------------------------------------------
  private static inline var parts:Array<String> =
    [ "source", "protocol", "authority", "userInfo", "user", "password", "host",
      "port", "relative", "path", "directory", "file", "query", "anchor"];


  //--------------------------------------------------------------------
  //------------------------------------------------------------ 
  public function new(url:String):Void
  {
    // Save for 'ron
    this.url = url;
 
    /*
     * This regexp actually has a bug, it doesn't correctly parse
     * file: protocol URLs with an absolute path leading slash.
     */

    // The almighty regexp (courtesy of
    // http://blog.stevenlevithan.com/archives/parseuri)
    var r:EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
 
    // Match the regexp to the url
    r.match(url);
 
    // Use reflection to set each part
    for (i in 0...parts.length) {
      Reflect.setField(this, parts[i],  r.matched(i));
    }
      // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------ 
  public static function parse(url:String):URLParser
  {
    return new URLParser(url);
  }

  // end URLParser
}
