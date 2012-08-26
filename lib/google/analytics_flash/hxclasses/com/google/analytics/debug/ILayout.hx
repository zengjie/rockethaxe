package com.google.analytics.debug;

extern interface ILayout {
	function addToPanel(p1 : String, p2 : flash.display.DisplayObject) : Void;
	function addToStage(p1 : flash.display.DisplayObject) : Void;
	function bringToFront(p1 : flash.display.DisplayObject) : Void;
	function createAlert(p1 : String) : Void;
	function createFailureAlert(p1 : String) : Void;
	function createGIFRequestAlert(p1 : String, p2 : flash.net.URLRequest, p3 : com.google.analytics.core.GIFRequest) : Void;
	function createInfo(p1 : String) : Void;
	function createPanel(p1 : String, p2 : UInt, p3 : UInt) : Void;
	function createSuccessAlert(p1 : String) : Void;
	function createVisualDebug() : Void;
	function createWarning(p1 : String) : Void;
	function destroy() : Void;
	function init() : Void;
	function isAvailable() : Bool;
}
