package com.rocketshipgames.haxe.util;

/**
 * This Haxe implementation of Jenkins' hash has been converted
 * directly from vkandy's JavaScript implementation, available here:
 *
 *   https://github.com/vkandy/jenkins-hash-js
 *
 * All I have done is convert to Haxe syntax, in particular:
 *   Function declarations;
 *   The JS fallthrough switch was converted to if statements.
 *
 *                                               - tjkopena (2013/08/23)
 */


class Jenkins
{

  private static var reverse32Lookup:Map<Int, String> = new Map();
  private static var reverse64Lookup:Map<Int, String> = new Map();

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function reverse32(hash:Int):String
  {
    return reverse32Lookup.get(hash);
  }

  public static function reverse64(hash:Int):String
  {
    return reverse64Lookup.get(hash);
  }


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public static function hash32(msg:String):Int
  {
    var h = lookup3(msg).c;
    reverse32Lookup.set(h, msg);
    return h;
  }

  public static function hash64(msg:String):Int
  {
    var l = lookup3(msg);
    var h = (l.b) + (l.c);
    reverse64Lookup.set(h, msg);
    return h;
  }

  //----------------------------------------------------
  public static function lookup3(k:String):Dynamic
  {
    var length = k.length;
    var a, b, c;

    a = b = c = 0xdeadbeef + length;

    var offset = 0;
    while (length > 12) {
      a += k.charCodeAt(offset + 0);
      a += k.charCodeAt(offset + 1) << 8;
      a += k.charCodeAt(offset + 2) << 16;
      a += k.charCodeAt(offset + 3) << 24;

      b += k.charCodeAt(offset + 4);
      b += k.charCodeAt(offset + 5) << 8;
      b += k.charCodeAt(offset + 6) << 16;
      b += k.charCodeAt(offset + 7) << 24;

      c += k.charCodeAt(offset + 8);
      c += k.charCodeAt(offset + 9) << 8;
      c += k.charCodeAt(offset + 10) << 16;
      c += k.charCodeAt(offset + 11) << 24;

      var mixed = mix(a, b, c);
      a = mixed.a;
      b = mixed.b;
      c = mixed.c;

      length -= 12;
      offset += 12;
    }

    if (length >= 12)
      c += k.charCodeAt(offset + 11) << 24;

    if (length >= 11)
      c += k.charCodeAt(offset + 10) << 16;

    if (length >= 10)
      c += k.charCodeAt(offset + 9) << 8;

    if (length >= 09)
      c += k.charCodeAt(offset + 8);

    if (length >= 08)
      b += k.charCodeAt(offset + 7) << 24;

    if (length >= 07)
      b += k.charCodeAt(offset + 6) << 16;

    if (length >= 06)
      b += k.charCodeAt(offset + 5) << 8;

    if (length >= 05)
      b += k.charCodeAt(offset + 4);

    if (length >= 04)
      a += k.charCodeAt(offset + 3) << 24;

    if (length >= 03)
      a += k.charCodeAt(offset + 2) << 16;

    if (length >= 02)
      a += k.charCodeAt(offset + 1) << 8;

    if (length >= 01)
      a += k.charCodeAt(offset + 0);
    else
      return {c: c >>> 0, b: b >>> 0};

    // Final mixing of three 32-bit values in to c
    var mixed = finalMix(a, b, c);
    a = mixed.a;
    b = mixed.b;
    c = mixed.c;

    return {c: c >>> 0, b: b >>> 0};
  }

  public static function mix(a, b, c) {
    a -= c; a ^= rot(c, 4); c += b; 
    b -= a; b ^= rot(a, 6); a += c;
    c -= b; c ^= rot(b, 8); b += a;
    a -= c; a ^= rot(c, 16); c += b;
    b -= a; b ^= rot(a, 19); a += c;
    c -= b; c ^= rot(b, 4); b += a;
    return {a : a, b : b, c: c};
  }

  public static function finalMix(a, b, c) {
    c ^= b; c -= rot(b, 14);
    a ^= c; a -= rot(c, 11);
    b ^= a; b -= rot(a, 25);
    c ^= b; c -= rot(b, 16);
    a ^= c; a -= rot(c, 4);
    b ^= a; b -= rot(a, 14);
    c ^= b; c -= rot(b, 24);
    return {a : a, b : b, c: c};
  }

  public static function rot(x, k) {
    return (((x) << (k)) | ((x) >> (32-(k))));
  }

  // end Jenkins
}
