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

package com.rocketshipgames.haxe.util;

import com.rocketshipgames.haxe.debug.Debug;

//----------------------------------------------------------------------
//----------------------------------------------------------------------
class Section
{

  //------------------------------------------------------------
  private var label:String;

  private var data:Hash<String>;

  //------------------------------------------------------------
  public function new(label:String):Void
  {
    this.label = label;
    data = new Hash();
    // end new
  }

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function set(key:String, value:String):Void
  {
    data.set(key, value);
    // end set
  }

  //------------------------------------------------------------
  public function exists(key:String):Bool
  {
    return data.exists(key);
  }

  public function getString(key:String, def:String=""):String
  {
    if (data.exists(key))
      return data.get(key);

    return def;
    // end getString
  }

  public function getInt(key:String, def:Int=0):Int
  {
    if (data.exists(key))
      return Std.parseInt(data.get(key));

    return def;
    // end getInt
  }

  public function getFloat(key:String, def:Float=0):Float
  {
    if (data.exists(key))
      return Std.parseFloat(data.get(key));

    return def;
    // end getFloat
  }

  public function getBool(key:String, def:Bool=false):Bool
  {
    if (data.exists(key)) {
      return (data.get(key) == "true");
    }
    return def;
    // end getBool
  }

  // end Section
}


//----------------------------------------------------------------------
//----------------------------------------------------------------------
class Config
{

  //------------------------------------------------------------
  private var sections:Hash<Section>;

  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public function new(xml:String):Void
  {
    if (xml == null) {
      Debug.error("No XML passed to Config.");
      return;
    }

    sections = new Hash();


    var root = Xml.parse(xml).firstElement();

    if (root == null) {
      Debug.error("No XML data parsed from:\n" + xml);
      return;
    }

    for (sectionNode in root.elements()) {
      var sectionLabel:String = sectionNode.nodeName;

      var section:Section = new Section(sectionLabel);
      sections.set(sectionLabel, section);

      for (keyNode in sectionNode.elements()) {
        var key:String = keyNode.nodeName;
        var value:String =
          (keyNode.firstChild() != null) ? keyNode.firstChild().nodeValue:null;

        section.set(key, value);
      }

      // end sectionNode
    }

    // end new
  }

  //------------------------------------------------------------
  public function exists(label:String):Bool
  {
    return sections.exists(label);
    // end exists
  }

  public function getSection(label:String):Section
  {
    if (sections.exists(label))
      return sections.get(label);

    var sec:Section = new Section(label);
    sections.set(label, sec);
    return sec;

    // end getSection
  }

  //------------------------------------------------------------
  public function getString(section:String, key:String, def:String=""):String
  {
    if (sections.exists(section))
      return sections.get(section).getString(key, def);

    return def;
    // end getString
  }

  public function getInt(section:String, key:String, def:Int=0):Int
  {
    if (sections.exists(section))
      return sections.get(section).getInt(key, def);

    return def;
    // end getInt
  }

  public function getFloat(section:String, key:String, def:Float=0):Float
  {
    if (sections.exists(section))
      return sections.get(section).getFloat(key, def);

    return def;
    // end getFloat
  }

  public function getBool(section:String, key:String, def:Bool=false):Bool
  {
    if (sections.exists(section))
        return sections.get(section).getBool(key, def);
    return def;
    // end getBool
  }

  // end Config
}
