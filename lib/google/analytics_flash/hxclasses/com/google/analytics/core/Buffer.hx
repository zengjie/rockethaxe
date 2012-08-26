package com.google.analytics.core;

extern class Buffer implements Dynamic {
	var utma(default,never) : com.google.analytics.data.UTMA;
	var utmb(default,never) : com.google.analytics.data.UTMB;
	var utmc(default,never) : com.google.analytics.data.UTMC;
	var utmk(default,never) : com.google.analytics.data.UTMK;
	var utmv(default,never) : com.google.analytics.data.UTMV;
	var utmz(default,never) : com.google.analytics.data.UTMZ;
	function new(p1 : com.google.analytics.v4.Configuration, p2 : com.google.analytics.debug.DebugConfiguration, p3 : Bool = false, ?p4 : Dynamic) : Void;
	function clearCookies() : Void;
	function generateCookiesHash() : Float;
	function hasUTMA() : Bool;
	function hasUTMB() : Bool;
	function hasUTMC() : Bool;
	function hasUTMK() : Bool;
	function hasUTMV() : Bool;
	function hasUTMZ() : Bool;
	function isGenuine() : Bool;
	function isVolatile() : Bool;
	function resetCurrentSession() : Void;
	function save() : Void;
	function update(p1 : String, p2 : Dynamic) : Void;
	function updateUTMA(p1 : Float) : Void;
}
