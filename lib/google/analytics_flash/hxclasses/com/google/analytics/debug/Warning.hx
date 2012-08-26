package com.google.analytics.debug;

extern class Warning extends Label {
	function new(?p1 : String, p2 : UInt = 3000) : Void;
	function close() : Void;
	function onComplete(p1 : flash.events.TimerEvent) : Void;
}
