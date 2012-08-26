package com.google.analytics.debug;

extern class Panel extends UISprite {
	var stickToEdge : Bool;
	var title : String;
	function new(p1 : String, p2 : UInt, p3 : UInt, p4 : UInt = 0, p5 : UInt = 0, p6 : Float = 0.3, ?p7 : Align, p8 : Bool = false) : Void;
	function addData(p1 : flash.display.DisplayObject) : Void;
	function close() : Void;
	function onToggle(?p1 : flash.events.MouseEvent) : Void;
}
