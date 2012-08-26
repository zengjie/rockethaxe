package com.google.analytics.external;

extern class HTMLDOM extends JavascriptProxy {
	var characterSet(default,never) : String;
	var colorDepth(default,never) : String;
	var host(default,never) : String;
	var language(default,never) : String;
	var location(default,never) : String;
	var pathname(default,never) : String;
	var protocol(default,never) : String;
	var referrer(default,never) : String;
	var search(default,never) : String;
	var title(default,never) : String;
	function new(p1 : com.google.analytics.debug.DebugConfiguration) : Void;
	function cacheProperties() : Void;
	static var cache_properties_js : flash.xml.XML;
}
