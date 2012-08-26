package com.google.analytics.core;

extern class IdleTimer {
	function new(p1 : com.google.analytics.v4.Configuration, p2 : com.google.analytics.debug.DebugConfiguration, p3 : flash.display.DisplayObject, p4 : Buffer) : Void;
	function checkForIdle(p1 : flash.events.TimerEvent) : Void;
	function endSession(p1 : flash.events.TimerEvent) : Void;
}
