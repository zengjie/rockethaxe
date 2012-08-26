package com.google.analytics.data;

extern class UTMZ extends UTMCookie {
	var campaignCreation : Float;
	var campaignSessions : Float;
	var campaignTracking : String;
	var domainHash : Float;
	var responseCount : Float;
	function new(p1 : Float = nan, p2 : Float = nan, p3 : Float = nan, p4 : Float = nan, ?p5 : String) : Void;
	static var defaultTimespan : Float;
}
