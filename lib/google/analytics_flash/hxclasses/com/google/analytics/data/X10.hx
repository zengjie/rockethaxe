package com.google.analytics.data;

extern class X10 {
	function new() : Void;
	function clearKey(p1 : Float) : Void;
	function clearValue(p1 : Float) : Void;
	function getKey(p1 : Float, p2 : Float) : String;
	function getValue(p1 : Float, p2 : Float) : Dynamic;
	function hasData() : Bool;
	function hasProject(p1 : Float) : Bool;
	function renderMergedUrlString(?p1 : X10) : String;
	function renderUrlString() : String;
	function setKey(p1 : Float, p2 : Float, p3 : String) : Bool;
	function setValue(p1 : Float, p2 : Float, p3 : Float) : Bool;
}
