package com.google.analytics.data;

extern class UTMB extends UTMCookie {
	var domainHash : Float;
	var lastTime : Float;
	var token : Float;
	var trackCount : Float;
	function new(p1 : Float = nan, p2 : Float = nan, p3 : Float = nan, p4 : Float = nan) : Void;
	static var defaultTimespan : Float;
}
