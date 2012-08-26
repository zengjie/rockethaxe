package com.google.analytics.v4;

extern class Tracker implements GoogleAnalyticsAPI {
	function new(p1 : String, p2 : Configuration, p3 : com.google.analytics.debug.DebugConfiguration, p4 : com.google.analytics.utils.Environment, p5 : com.google.analytics.core.Buffer, p6 : com.google.analytics.core.GIFRequest, p7 : com.google.analytics.external.AdSenseGlobals) : Void;
	function addIgnoredOrganic(p1 : String) : Void;
	function addIgnoredRef(p1 : String) : Void;
	function addItem(p1 : String, p2 : String, p3 : String, p4 : String, p5 : Float, p6 : Int) : Void;
	function addOrganic(p1 : String, p2 : String) : Void;
	function addTrans(p1 : String, p2 : String, p3 : Float, p4 : Float, p5 : Float, p6 : String, p7 : String, p8 : String) : Dynamic;
	function clearIgnoredOrganic() : Void;
	function clearIgnoredRef() : Void;
	function clearOrganic() : Void;
	function cookiePathCopy(p1 : String) : Void;
	function createEventTracker(p1 : String) : com.google.analytics.core.EventTracker;
	function getAccount() : String;
	function getClientInfo() : Bool;
	function getDetectFlash() : Bool;
	function getDetectTitle() : Bool;
	function getLocalGifPath() : String;
	function getServiceMode() : com.google.analytics.core.ServerOperationMode;
	function getVersion() : String;
	function link(p1 : String, p2 : Bool = false) : Void;
	function linkByPost(p1 : Dynamic, p2 : Bool = false) : Void;
	function resetSession() : Void;
	function setAllowAnchor(p1 : Bool) : Void;
	function setAllowHash(p1 : Bool) : Void;
	function setAllowLinker(p1 : Bool) : Void;
	function setCampContentKey(p1 : String) : Void;
	function setCampMediumKey(p1 : String) : Void;
	function setCampNOKey(p1 : String) : Void;
	function setCampNameKey(p1 : String) : Void;
	function setCampSourceKey(p1 : String) : Void;
	function setCampTermKey(p1 : String) : Void;
	function setCampaignTrack(p1 : Bool) : Void;
	function setClientInfo(p1 : Bool) : Void;
	function setCookiePath(p1 : String) : Void;
	function setCookieTimeout(p1 : Int) : Void;
	function setDetectFlash(p1 : Bool) : Void;
	function setDetectTitle(p1 : Bool) : Void;
	function setDomainName(p1 : String) : Void;
	function setLocalGifPath(p1 : String) : Void;
	function setLocalRemoteServerMode() : Void;
	function setLocalServerMode() : Void;
	function setRemoteServerMode() : Void;
	function setSampleRate(p1 : Float) : Void;
	function setSessionTimeout(p1 : Int) : Void;
	function setVar(p1 : String) : Void;
	function trackEvent(p1 : String, p2 : String, ?p3 : String, p4 : Float = nan) : Bool;
	function trackPageview(?p1 : String) : Void;
	function trackTrans() : Void;
}
