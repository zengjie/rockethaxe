package com.google.analytics.debug;

extern class DebugConfiguration {
	var GIFRequests : Bool;
	var active : Bool;
	var destroyKey : Float;
	var infoTimeout : Float;
	var javascript : Bool;
	var layout : ILayout;
	var minimizedOnStart : Bool;
	var mode : Dynamic;
	var showHideKey : Float;
	var showInfos : Bool;
	var showWarnings : Bool;
	var traceOutput : Bool;
	var verbose : Bool;
	var warningTimeout : Float;
	function new() : Void;
	function alert(p1 : String) : Void;
	function alertGifRequest(p1 : String, p2 : flash.net.URLRequest, p3 : com.google.analytics.core.GIFRequest) : Void;
	function failure(p1 : String) : Void;
	function info(p1 : String, ?p2 : VisualDebugMode) : Void;
	function success(p1 : String) : Void;
	function warning(p1 : String, ?p2 : VisualDebugMode) : Void;
}
