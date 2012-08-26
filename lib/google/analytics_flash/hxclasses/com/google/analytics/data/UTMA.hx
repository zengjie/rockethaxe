package com.google.analytics.data;

extern class UTMA extends UTMCookie {
	var currentTime : Float;
	var domainHash : Float;
	var firstTime : Float;
	var lastTime : Float;
	var sessionCount : Float;
	var sessionId : Float;
	function new(p1 : Float = nan, p2 : Float = nan, p3 : Float = nan, p4 : Float = nan, p5 : Float = nan, p6 : Float = nan) : Void;
}
