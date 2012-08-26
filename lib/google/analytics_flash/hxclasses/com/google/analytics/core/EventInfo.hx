package com.google.analytics.core;

extern class EventInfo {
	var utme(default,never) : String;
	var utmt(default,never) : String;
	function new(p1 : Bool, p2 : com.google.analytics.data.X10, ?p3 : com.google.analytics.data.X10) : Void;
	function toURLString() : String;
	function toVariables() : com.google.analytics.utils.Variables;
}
