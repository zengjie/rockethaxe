package com.google.analytics.debug;

extern class Label extends UISprite {
	var stickToEdge : Bool;
	var tag : String;
	var text : String;
	function new(?p1 : String, ?p2 : String, p3 : UInt = 0, ?p4 : Align, p5 : Bool = false) : Void;
	function appendText(p1 : String, ?p2 : String) : Void;
	function onLink(p1 : flash.events.TextEvent) : Void;
	static var count : UInt;
}
