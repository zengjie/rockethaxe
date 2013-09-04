package com.rocketshipgames.haxe.physics;

import com.rocketshipgames.haxe.component.CapabilityID;
import com.rocketshipgames.haxe.component.ComponentContainer;


/**
 * Common physics capabilities (interfaces) capability IDs are defined here.
 */


class PhysicsCapabilities
{

  public static var CID_POSITION2D:CapabilityID =
    ComponentContainer.hashID("cid_position2d");

  public static var CID_KINEMATICS2D:CapabilityID =
    ComponentContainer.hashID("cid_kinematics2d");

  public static var CID_EXTENT2D:CapabilityID =
    ComponentContainer.hashID("cid_extent2d");

  // end PhysicsCapabilities
}
