package com.google.analytics.core;

extern class GIFRequest {
	var utmac(default,never) : String;
	var utmcc(default,never) : String;
	var utmhn(default,never) : String;
	var utmn(default,never) : String;
	var utmsp(default,never) : String;
	var utmwv(default,never) : String;
	function new(p1 : com.google.analytics.v4.Configuration, p2 : com.google.analytics.debug.DebugConfiguration, p3 : Buffer, p4 : com.google.analytics.utils.Environment) : Void;
	function onComplete(p1 : flash.events.Event) : Void;
	function onIOError(p1 : flash.events.IOErrorEvent) : Void;
	function onSecurityError(p1 : flash.events.SecurityErrorEvent) : Void;
	function send(p1 : String, ?p2 : com.google.analytics.utils.Variables, p3 : Bool = false, p4 : Bool = false) : Void;
	function sendRequest(p1 : flash.net.URLRequest) : Void;
	function updateToken() : Void;
}
