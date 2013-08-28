package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.CapabilityID;
import com.rocketshipgames.haxe.component.ComponentContainer;


/**
 * Common physics capabilities (interfaces) capability IDs are defined here.
 */


class PhysicsCapabilities
{

  public static var CID_POSITION2D:CapabilityID =
    ComponentContainer.hashID("position-2d");

  public static var CID_EXTENT2D:CapabilityID =
    ComponentContainer.hashID("extent-2d");

  // end PhysicsCapabilities
}
