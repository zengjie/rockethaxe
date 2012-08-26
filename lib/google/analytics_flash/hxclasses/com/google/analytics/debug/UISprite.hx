package com.google.analytics.debug;

extern class UISprite extends flash.display.Sprite {
	var alignement : Align;
	var forcedHeight : UInt;
	var forcedWidth : UInt;
	var margin : Margin;
	function new(?p1 : flash.display.DisplayObject) : Void;
	function alignTo(p1 : Align, ?p2 : flash.display.DisplayObject) : Void;
	function resize() : Void;
}
