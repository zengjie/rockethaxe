package com.google.analytics.debug;

extern class Alert extends Label {
	var actionOnNextLine : Bool;
	var autoClose : Bool;
	function new(p1 : String, p2 : Array<Dynamic>, ?p3 : String, p4 : UInt = 0, ?p5 : Align, p6 : Bool = false, p7 : Bool = true) : Void;
	function close() : Void;
}
