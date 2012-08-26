package com.google.analytics.debug;

extern class VisualDebugMode {
	function new(p1 : Int = 0, ?p2 : String) : Void;
	function toString() : String;
	function valueOf() : Int;
	static var advanced : VisualDebugMode;
	static var basic : VisualDebugMode;
	static var geek : VisualDebugMode;
}
