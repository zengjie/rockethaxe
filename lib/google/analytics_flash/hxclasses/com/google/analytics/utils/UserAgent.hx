package com.google.analytics.utils;

extern class UserAgent {
	var applicationComment(default,never) : String;
	var applicationProduct : String;
	var applicationProductToken(default,never) : String;
	var applicationVersion : String;
	var tamarinProductToken(default,never) : String;
	var vendorProductToken(default,never) : String;
	function new(p1 : Environment, ?p2 : String, ?p3 : String) : Void;
	function toString() : String;
	static var minimal : Bool;
}
