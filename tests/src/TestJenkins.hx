package ;

import com.rocketshipgames.haxe.util.Jenkins;

/**
 * Honestly, I looked at the very simple test cases in Jenkins'
 * archived lookup3.c (http://burtleburtle.net/bob/c/lookup3.c) and am
 * not producing the same values.  I didn't take the time to diagnose
 * further.  I could not readily find another good test suite or even
 * some given key->value pairs, so the test here should be considered
 * one of regression, not correctness.
 * 
 *                                               - tjkopena (2013/08/23)
 */


class TestJenkins
{

  public static function main():Void
  {
    trace("Jenkins Hash Test");

    var data =
      [
       { k: "", res: 0xdeadbeef},
       { k: "Four score and seven years ago", res: 0x703EC786},
       { k: "deadbeef", res: 0x6A5435FF},
       { k: "Jenkins", res: 0xEFDAA071},
       { k: "Murmur", res: 0x80000000},
       { k: "City", res: 0xE6C4214F},
       { k: "0", res: 0x859715F6},
      ];

    for (test in data) {
      var h32 = Jenkins.hash32(test.k);

      trace("'" + test.k + "'  " +
            StringTools.hex(h32, 8) + "  " +
            StringTools.hex(test.res, 8) +
            ((h32 != test.res) ? " ERROR" : ""));
    }

    // end main
  }

  // end TestJenkins
}
