package com.google.analytics.utils;

extern class Protocols {
	function new(p1 : Int = 0, ?p2 : String) : Void;
	function toString() : String;
	function valueOf() : Int;
	static var HTTP : Protocols;
	static var HTTPS : Protocols;
	static var file : Protocols;
	static var none : Protocols;
}
