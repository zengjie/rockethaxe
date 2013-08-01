package com.rocketshipgames.haxe.debug;

class Debug {

  public static function debug(v:Dynamic, ?pos:haxe.PosInfos):Void
  {
    haxe.Log.trace(v, pos);
  }

  public static function error(v:Dynamic, ?pos:haxe.PosInfos):Void
  {
    haxe.Log.trace("[ERROR] " + v, pos);
  }

  /*
   * TODO: Figure out why console trace doesn't work anymore?
   *
  public static function enableConsoleTrace():Bool
  {
    //    #if (flash9 || flash10)
    //      haxe.Log.trace = function(v,?pos) { untyped __global__["trace"](pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",v); }
    #if flash
      haxe.Log.trace = function(v,?pos) { flash.Lib.trace(pos.className+"#"+pos.methodName+"("+pos.lineNumber+"): "+v); }
    #end

      return true;

    // end function enableConsoleTrace
  }
  */

  // end class Debug
}
