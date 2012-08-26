package com.google.analytics.core;

extern class EventTracker {
	var name : String;
	function new(p1 : String, p2 : com.google.analytics.v4.GoogleAnalyticsAPI) : Void;
	function trackEvent(p1 : String, ?p2 : String, p3 : Float = nan) : Bool;
}
