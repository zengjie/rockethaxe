package com.google.analytics.utils;

extern class Environment {
	var appName : String;
	var appVersion : Version;
	var documentTitle(default,never) : String;
	var domainName(default,never) : String;
	var flashVersion(default,never) : Version;
	var language(default,never) : String;
	var languageEncoding(default,never) : String;
	var locationPath(default,never) : String;
	var locationSWFPath(default,never) : String;
	var locationSearch(default,never) : String;
	var operatingSystem(default,never) : String;
	var platform(default,never) : String;
	var playerType(default,never) : String;
	var protocol(default,never) : Protocols;
	var referrer(default,never) : String;
	var screenColorDepth(default,never) : String;
	var screenHeight(default,never) : Float;
	var screenWidth(default,never) : Float;
	var url(never,default) : String;
	var userAgent : UserAgent;
	function new(?p1 : String, ?p2 : String, ?p3 : String, ?p4 : com.google.analytics.debug.DebugConfiguration, ?p5 : com.google.analytics.external.HTMLDOM) : Void;
	function isAIR() : Bool;
	function isInHTML() : Bool;
}
