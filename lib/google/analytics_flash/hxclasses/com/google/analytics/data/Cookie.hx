package com.google.analytics.data;

extern interface Cookie {
	var creation : Date;
	var expiration : Date;
	function fromSharedObject(p1 : Dynamic) : Void;
	function isExpired() : Bool;
	function toSharedObject() : Dynamic;
	function toURLString() : String;
}
