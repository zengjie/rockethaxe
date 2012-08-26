package com.google.analytics.utils;

extern class Variables implements Dynamic {
	var URIencode : Bool;
	var post : Array<Dynamic>;
	var pre : Array<Dynamic>;
	var sort : Bool;
	function new(?p1 : String, ?p2 : Array<Dynamic>, ?p3 : Array<Dynamic>) : Void;
	function decode(p1 : String) : Void;
	function join(?p1 : Dynamic, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic) : Void;
	function toString() : String;
	function toURLVariables() : flash.net.URLVariables;
}
