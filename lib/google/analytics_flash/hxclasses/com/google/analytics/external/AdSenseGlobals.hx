package com.google.analytics.external;

extern class AdSenseGlobals extends JavascriptProxy {
	var dh(default,never) : String;
	var gaGlobal(default,never) : Dynamic;
	var hid : String;
	var sid : String;
	var vid : String;
	function new(p1 : com.google.analytics.debug.DebugConfiguration) : Void;
	static var gaGlobal_js : flash.xml.XML;
}
