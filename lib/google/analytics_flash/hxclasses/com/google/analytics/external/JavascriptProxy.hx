package com.google.analytics.external;

extern class JavascriptProxy {
	function new(p1 : com.google.analytics.debug.DebugConfiguration) : Void;
	function call(p1 : String, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic, ?p6 : Dynamic) : Dynamic;
	function executeBlock(p1 : String) : Void;
	function getProperty(p1 : String) : Dynamic;
	function getPropertyString(p1 : String) : String;
	function hasProperty(p1 : String) : Bool;
	function isAvailable() : Bool;
	function setProperty(p1 : String, p2 : Dynamic) : Void;
	function setPropertyByReference(p1 : String, p2 : String) : Void;
	static var hasProperty_js : flash.xml.XML;
	static var setPropertyRef_js : flash.xml.XML;
	static var setProperty_js : flash.xml.XML;
}
