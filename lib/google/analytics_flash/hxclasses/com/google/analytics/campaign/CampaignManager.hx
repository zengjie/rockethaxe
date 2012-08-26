package com.google.analytics.campaign;

extern class CampaignManager {
	function new(p1 : com.google.analytics.v4.Configuration, p2 : com.google.analytics.debug.DebugConfiguration, p3 : com.google.analytics.core.Buffer, p4 : Float, p5 : String, p6 : Float) : Void;
	function getCampaignInformation(p1 : String, p2 : Bool) : CampaignInfo;
	function getDirectCampaign() : CampaignTracker;
	function getOrganicCampaign() : CampaignTracker;
	function getReferrerCampaign() : CampaignTracker;
	function getTrackerFromSearchString(p1 : String) : CampaignTracker;
	function hasNoOverride(p1 : String) : Bool;
	function isIgnoredKeyword(p1 : CampaignTracker) : Bool;
	function isIgnoredReferral(p1 : CampaignTracker) : Bool;
	function isValid(p1 : CampaignTracker) : Bool;
	static var trackingDelimiter : String;
	static function isFromGoogleCSE(p1 : String, p2 : com.google.analytics.v4.Configuration) : Bool;
	static function isInvalidReferrer(p1 : String) : Bool;
}
