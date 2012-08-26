package com.google.analytics.utils;

extern class Version {
	var build : UInt;
	var major : UInt;
	var minor : UInt;
	var revision : UInt;
	function new(p1 : UInt = 0, p2 : UInt = 0, p3 : UInt = 0, p4 : UInt = 0) : Void;
	function equals(p1 : Dynamic) : Bool;
	function toString(p1 : Int = 0) : String;
	function valueOf() : UInt;
	static function fromNumber(p1 : Float = 0) : Version;
	static function fromString(?p1 : String, ?p2 : String) : Version;
}
