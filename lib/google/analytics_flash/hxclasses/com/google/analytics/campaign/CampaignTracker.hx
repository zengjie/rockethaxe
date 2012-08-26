package com.google.analytics.campaign;

extern class CampaignTracker {
	var clickId : String;
	var content : String;
	var id : String;
	var medium : String;
	var name : String;
	var source : String;
	var term : String;
	function new(?p1 : String, ?p2 : String, ?p3 : String, ?p4 : String, ?p5 : String, ?p6 : String, ?p7 : String) : Void;
	function fromTrackerString(p1 : String) : Void;
	function isValid() : Bool;
	function toTrackerString() : String;
}
