package com.google.analytics.data;

extern class UTMCookie implements Cookie {
	var creation : Date;
	var expiration : Date;
	var proxy : com.google.analytics.core.Buffer;
	function new(p1 : String, p2 : String, p3 : Array<Dynamic>, p4 : Float = 0) : Void;
	function fromSharedObject(p1 : Dynamic) : Void;
	function isEmpty() : Bool;
	function isExpired() : Bool;
	function reset() : Void;
	function resetTimestamp(p1 : Float = nan) : Void;
	function toSharedObject() : Dynamic;
	function toString(p1 : Bool = false) : String;
	function toURLString() : String;
	function valueOf() : String;
}
