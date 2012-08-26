package com.google.analytics.core;

extern class Organic {
	var count(default,never) : Int;
	var ignoredKeywordsCount(default,never) : Int;
	var ignoredReferralsCount(default,never) : Int;
	var sources(default,never) : Array<Dynamic>;
	function new() : Void;
	function addIgnoredKeyword(p1 : String) : Void;
	function addIgnoredReferral(p1 : String) : Void;
	function addSource(p1 : String, p2 : String) : Void;
	function clear() : Void;
	function clearEngines() : Void;
	function clearIgnoredKeywords() : Void;
	function clearIgnoredReferrals() : Void;
	function getKeywordValue(p1 : OrganicReferrer, p2 : String) : String;
	function getReferrerByName(p1 : String) : OrganicReferrer;
	function isIgnoredKeyword(p1 : String) : Bool;
	function isIgnoredReferral(p1 : String) : Bool;
	function match(p1 : String) : Bool;
	static var throwErrors : Bool;
	static function getKeywordValueFromPath(p1 : String, p2 : String) : String;
}
