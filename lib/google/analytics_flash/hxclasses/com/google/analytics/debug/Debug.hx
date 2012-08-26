package com.google.analytics.debug;

extern class Debug extends Label {
	var maxLines : UInt;
	function new(p1 : UInt = 0, ?p2 : Align, p3 : Bool = false) : Void;
	function close() : Void;
	function write(p1 : String, p2 : Bool = false) : Void;
	function writeBold(p1 : String) : Void;
	static var count : UInt;
}
