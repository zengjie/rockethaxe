package com.google.analytics.v4;

extern class Configuration {
	var allowAnchor : Bool;
	var allowDomainHash : Bool;
	var allowLinker : Bool;
	var allowLocalTracking : Bool;
	var bucketCapacity : Float;
	var campaignKey : com.google.analytics.campaign.CampaignKey;
	var campaignTracking : Bool;
	var conversionTimeout : Float;
	var cookieName(default,never) : String;
	var cookiePath : String;
	var detectClientInfo : Bool;
	var detectFlash : Bool;
	var detectTitle : Bool;
	var domain(default,never) : com.google.analytics.core.Domain;
	var domainName : String;
	var google : String;
	var googleCsePath : String;
	var googleSearchParam : String;
	var hasSiteOverlay : Bool;
	var idleLoop : Float;
	var idleTimeout : Float;
	var isTrackOutboundSubdomains : Bool;
	var localGIFpath : String;
	var maxOutboundLinkExamined : Float;
	var organic(default,never) : com.google.analytics.core.Organic;
	var remoteGIFpath : String;
	var sampleRate : Float;
	var secureRemoteGIFpath : String;
	var serverMode : com.google.analytics.core.ServerOperationMode;
	var sessionTimeout : Float;
	var tokenCliff : Int;
	var tokenRate : Float;
	var trackingLimitPerSession(default,never) : Int;
	var transactionFieldDelim : String;
	var version(default,never) : String;
	function new(?p1 : com.google.analytics.debug.DebugConfiguration) : Void;
	function addOrganicSource(p1 : String, p2 : String) : Void;
}
