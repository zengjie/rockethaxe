package com.google.analytics.debug;

extern class AlertAction {
	var activator : String;
	var container : Alert;
	var name : String;
	function new(p1 : String, p2 : String, p3 : Dynamic) : Void;
	function execute() : Void;
}
