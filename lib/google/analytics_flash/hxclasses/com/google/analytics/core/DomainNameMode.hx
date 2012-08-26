package com.google.analytics.core;

extern class DomainNameMode {
	function new(p1 : Int = 0, ?p2 : String) : Void;
	function toString() : String;
	function valueOf() : Int;
	static var auto : DomainNameMode;
	static var custom : DomainNameMode;
	static var none : DomainNameMode;
}
