package com.rocketshipgames.haxe.device;

import flash.events.KeyboardEvent;

/*
 * Lifted largely from HaxePunk by Matt Tuttle (http://haxepunk.com/
 * https://github.com/MattTuttle/HaxePunk) and neash.ui.Keyboard
 */

/*
 * Note that on the NME cpp target, the F keys use the same codes as
 * the alphanumeric keys.  I have no idea why, but I gather that's
 * pretty much just the way it is right now.  No clear workaround.
 *                                                            - tjkopena
 */


class Keyboard
{
  public inline static var ANY                  = -1;

  public inline static var BACKSPACE            = 8;
  public inline static var TAB                  = 9;
  public inline static var ENTER                = 13;
  public inline static var COMMAND              = 15;
  public inline static var SHIFT                = 16;
  public inline static var CONTROL              = 17;
  public inline static var ALTERNATE            = 18;
  public inline static var CAPS_LOCK            = 20;
  public inline static var NUMPAD               = 21;
  public inline static var ESCAPE               = 27;
  public inline static var SPACE                = 32;

  public inline static var PAGE_UP              = 33;
  public inline static var PAGE_DOWN            = 34;
  public inline static var END                  = 35;
  public inline static var HOME                 = 36;

  public inline static var LEFT                 = 37;
  public inline static var UP                   = 38;
  public inline static var RIGHT                = 39;
  public inline static var DOWN                 = 40;

  public inline static var INSERT               = 45;
  public inline static var DELETE               = 46;


  #if flash
    public inline static var A                  = 65;
    public inline static var B                  = 66;
    public inline static var C                  = 67;
    public inline static var D                  = 68;
    public inline static var E                  = 69;
    public inline static var F                  = 70;
    public inline static var G                  = 71;
    public inline static var H                  = 72;
    public inline static var I                  = 73;
    public inline static var J                  = 74;
    public inline static var K                  = 75;
    public inline static var L                  = 76;
    public inline static var M                  = 77;
    public inline static var N                  = 78;
    public inline static var O                  = 79;
    public inline static var P                  = 80;
    public inline static var Q                  = 81;
    public inline static var R                  = 82;
    public inline static var S                  = 83;
    public inline static var T                  = 84;
    public inline static var U                  = 85;
    public inline static var V                  = 86;
    public inline static var W                  = 87;
    public inline static var X                  = 88;
    public inline static var Y                  = 89;
    public inline static var Z                  = 90;

  #else
    public inline static var A                  = 97;
    public inline static var B                  = 98;
    public inline static var C                  = 99;
    public inline static var D                  = 100;
    public inline static var E                  = 101;
    public inline static var F                  = 102;
    public inline static var G                  = 103;
    public inline static var H                  = 104;
    public inline static var I                  = 105;
    public inline static var J                  = 106;
    public inline static var K                  = 107;
    public inline static var L                  = 108;
    public inline static var M                  = 109;
    public inline static var N                  = 110;
    public inline static var O                  = 111;
    public inline static var P                  = 112;
    public inline static var Q                  = 113;
    public inline static var R                  = 114;
    public inline static var S                  = 115;
    public inline static var T                  = 116;
    public inline static var U                  = 117;
    public inline static var V                  = 118;
    public inline static var W                  = 119;
    public inline static var X                  = 120;
    public inline static var Y                  = 121;
    public inline static var Z                  = 122;
  #end


  public inline static var F1                   = 112;
  public inline static var F2                   = 113;
  public inline static var F3                   = 114;
  public inline static var F4                   = 115;
  public inline static var F5                   = 116;
  public inline static var F6                   = 117;
  public inline static var F7                   = 118;
  public inline static var F8                   = 119;
  public inline static var F9                   = 120;
  public inline static var F10                  = 121;
  public inline static var F11                  = 122;
  public inline static var F12                  = 123;
  public inline static var F13                  = 124;
  public inline static var F14                  = 125;
  public inline static var F15                  = 126;

  public inline static var DIGIT_0              = 48;
  public inline static var DIGIT_1              = 49;
  public inline static var DIGIT_2              = 50;
  public inline static var DIGIT_3              = 51;
  public inline static var DIGIT_4              = 52;
  public inline static var DIGIT_5              = 53;
  public inline static var DIGIT_6              = 54;
  public inline static var DIGIT_7              = 55;
  public inline static var DIGIT_8              = 56;
  public inline static var DIGIT_9              = 57;

  public inline static var NUMPAD_0             = 96;
  public inline static var NUMPAD_1             = 97;
  public inline static var NUMPAD_2             = 98;
  public inline static var NUMPAD_3             = 99;
  public inline static var NUMPAD_4             = 100;
  public inline static var NUMPAD_5             = 101;
  public inline static var NUMPAD_6             = 102;
  public inline static var NUMPAD_7             = 103;
  public inline static var NUMPAD_8             = 104;
  public inline static var NUMPAD_9             = 105;

  public inline static var NUMPAD_ADD           = 107;
  public inline static var NUMPAD_MULTIPLY      = 106;
  public inline static var NUMPAD_ENTER         = 108;
  public inline static var NUMPAD_SUBTRACT      = 109;
  public inline static var NUMPAD_DECIMAL       = 110;
  public inline static var NUMPAD_DIVIDE        = 111;

  public inline static var PERIOD               = 190;
  public inline static var BACKQUOTE            = 192;
  public inline static var SEMICOLON            = 186;
  public inline static var EQUAL                = 187;
  public inline static var COMMA                = 188;
  public inline static var MINUS                = 189;
  public inline static var SLASH                = 191;
  public inline static var LEFT_SQUARE_BRACKET  = 219;
  public inline static var RIGHT_SQUARE_BRACKET = 221;
  public inline static var BACKSLASH            = 220;
  public inline static var QUOTE                = 222;


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  private static var keyDown:Array<Bool> = new Array();
  private static var keyTrack:Array<Bool> = new Array();


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function onKeyDown(event:KeyboardEvent)
  {
    keyTrack[event.keyCode] = !keyDown[event.keyCode];
    keyDown[event.keyCode] = true;
    // end function onKeyDown
  }

  public static function onKeyUp(event:KeyboardEvent)
  {
    keyTrack[event.keyCode] = false;
    keyDown[event.keyCode] = false;
    // end function onKeyUp
  }

  public static function isKeyDown(code:Int):Bool
  {
    keyTrack[code] = false;
    return keyDown[code];
  }

  public static function isKeyPressed(code:Int):Bool
  {
    var res:Bool = keyTrack[code];
    keyTrack[code] = false;
    return res;
    // end function keyCheck
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function name(char:Int):String
  {

    if (char >= A && char <= Z)
      return String.fromCharCode(char).toUpperCase();

    if (char >= F1 && char <= F15)
      return "F" + (char - (F1-1));

    if (char >= DIGIT_0 && char <= DIGIT_9)
      return Std.string(char - DIGIT_0);

    if (char >= NUMPAD_0 && char <= NUMPAD_9)
      return "NUMPAD " + Std.string(char - NUMPAD_0);

    switch (char)
      {
      case ANY:                     return "ANY";

      case BACKSPACE:               return "BACKSPACE";
      case TAB:                     return "TAB";
      case ENTER:                   return "ENTER";
      case COMMAND:                 return "COMMAND";
      case SHIFT:                   return "SHIFT";
      case CONTROL:                 return "CONTROL";
      case ALTERNATE:               return "ALTERNATE";
      case CAPS_LOCK:               return "CAPS LOCK";
      case NUMPAD:                  return "NUMPAD";
      case ESCAPE:                  return "ESCAPE";
      case SPACE:                   return "SPACE";

      case PAGE_UP:                 return "PAGE UP";
      case PAGE_DOWN:               return "PAGE DOWN";
      case END:                     return "END";
      case HOME:                    return "HOME";

      case LEFT:                    return "LEFT";
      case UP:                      return "UP";
      case RIGHT:                   return "RIGHT";
      case DOWN:                    return "DOWN";

      case INSERT:                  return "INSERT";
      case DELETE:                  return "DELETE";

      case NUMPAD_ADD:              return "NUMPAD ADD";
      case NUMPAD_MULTIPLY:         return "NUMPAD MULTIPLY";
      case NUMPAD_ENTER:            return "NUMPAD ENTER";
      case NUMPAD_SUBTRACT:         return "NUMPAD SUBTRACT";
      case NUMPAD_DECIMAL:          return "NUMPAD DECIMAL";
      case NUMPAD_DIVIDE:           return "NUMPAD DIVIDE";

      case PERIOD:                  return "PERIOD";
      case BACKQUOTE:               return "BACKQUOTE";
      case SEMICOLON:               return "SEMICOLON";
      case EQUAL:                   return "EQUAL";
      case COMMA:                   return "COMMA";
      case MINUS:                   return "MINUS";
      case SLASH:                   return "SLASH";
      case LEFT_SQUARE_BRACKET:     return "LEFT BRACKET";
      case RIGHT_SQUARE_BRACKET:    return "RIGHT BRACKET";
      case BACKSLASH:               return "BACKSLASH";
      case QUOTE:                   return "QUOTE";
      }

    return String.fromCharCode(char);
    // end name
  }

  // end Keyboard
}
