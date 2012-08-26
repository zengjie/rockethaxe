package com.google.analytics.core;

extern class Utils {
	function new() : Void;
	static function generate32bitRandom() : Int;
	static function generateHash(p1 : String) : Int;
	static function trim(p1 : String, p2 : Bool = false) : String;
	static function validateAccount(p1 : String) : Bool;
}
