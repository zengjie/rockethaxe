package com.google.analytics.core;

extern class BrowserInfo {
	var utmcs(default,never) : String;
	var utmfl(default,never) : String;
	var utmje(default,never) : String;
	var utmsc(default,never) : String;
	var utmsr(default,never) : String;
	var utmul(default,never) : String;
	function new(p1 : com.google.analytics.v4.Configuration, p2 : com.google.analytics.utils.Environment) : Void;
	function toURLString() : String;
	function toVariables() : com.google.analytics.utils.Variables;
}
