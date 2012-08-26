package com.google.analytics.utils;

extern class URL {
	var domain(default,never) : String;
	var hostName(default,never) : String;
	var path(default,never) : String;
	var protocol(default,never) : Protocols;
	var search(default,never) : String;
	var subDomain(default,never) : String;
	function new(?p1 : String) : Void;
}
