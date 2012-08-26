package com.google.analytics.campaign;

extern class CampaignInfo {
	var utmcn(default,never) : String;
	var utmcr(default,never) : String;
	function new(p1 : Bool = true, p2 : Bool = false) : Void;
	function isEmpty() : Bool;
	function isNew() : Bool;
	function toURLString() : String;
	function toVariables() : com.google.analytics.utils.Variables;
}
