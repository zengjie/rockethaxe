package com.google.analytics;

extern interface AnalyticsTracker implements flash.events.IEventDispatcher, implements com.google.analytics.v4.GoogleAnalyticsAPI {
	var account : String;
	var config : com.google.analytics.v4.Configuration;
	var debug : com.google.analytics.debug.DebugConfiguration;
	var mode : String;
	var visualDebug : Bool;
	function isReady() : Bool;
}
