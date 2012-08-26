package com.google.analytics.core;

extern class DocumentInfo {
	var utmdt(default,never) : String;
	var utmhid(default,never) : String;
	var utmp(default,never) : String;
	var utmr(default,never) : String;
	function new(p1 : com.google.analytics.v4.Configuration, p2 : com.google.analytics.utils.Environment, p3 : String, ?p4 : String, ?p5 : com.google.analytics.external.AdSenseGlobals) : Void;
	function toURLString() : String;
	function toVariables() : com.google.analytics.utils.Variables;
}
