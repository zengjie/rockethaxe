package com.google.analytics.events;

extern class AnalyticsEvent extends flash.events.Event {
	var tracker : com.google.analytics.AnalyticsTracker;
	function new(p1 : String, p2 : com.google.analytics.AnalyticsTracker, p3 : Bool = false, p4 : Bool = false) : Void;
	static var READY : String;
}
