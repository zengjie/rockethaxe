package com.google.analytics.core;

extern class ServerOperationMode {
	function new(p1 : Int = 0, ?p2 : String) : Void;
	function toString() : String;
	function valueOf() : Int;
	static var both : ServerOperationMode;
	static var local : ServerOperationMode;
	static var remote : ServerOperationMode;
}
