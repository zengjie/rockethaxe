package com.google.analytics.core;

extern class RequestObject {
	var duration(default,never) : Int;
	var end : Int;
	var request : flash.net.URLRequest;
	var start : Int;
	function new(p1 : flash.net.URLRequest) : Void;
	function complete() : Void;
	function hasCompleted() : Bool;
	function toString() : String;
}
