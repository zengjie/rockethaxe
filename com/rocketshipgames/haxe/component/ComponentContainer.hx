package com.rocketshipgames.haxe.component;

import com.rocketshipgames.haxe.debug.Debug;

import com.rocketshipgames.haxe.ds.DoubleLinkedList;
import com.rocketshipgames.haxe.ds.DoubleLinkedListHandle;
import com.rocketshipgames.haxe.ds.DoubleLinkedListIterator;

import com.rocketshipgames.haxe.util.Jenkins;


class ComponentContainer
  implements Component
{
  public static var CID_NULL:CapabilityID = 0;

  public var signals(get_signals,null):SignalDispatcher;
  public var states(get_states,null):StateKeeper;
  public var events(get_events,null):Scheduler;

  //--------------------------------------------------------------------
  //----------------------------------------------------
  private var components:DoubleLinkedList<ComponentHandle>;

  private var capabilities:Map<CapabilityID,ComponentHandle>;

  private var container:ComponentHandle;

  private var active:Bool;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new():Void
  {
    components = new DoubleLinkedList();
    capabilities = new Map();
    active = true;
    // end new
  }

  //----------------------------------------------------
  public function get_signals():SignalDispatcher
  {
    if (signals == null)
      signals = new SignalDispatcher();
    return signals;
    // end get_signals
  }

  public function get_states():StateKeeper
  {
    if (states == null)
      states = new StateKeeper();
    return states;
    // end get_states
  }

  public function get_events():Scheduler
  {
    if (events == null)
      events = new Scheduler();
    return events;
    // end get_events
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function attach(containerHandle:ComponentHandle):Void
  {
    container = containerHandle;
  }

  public function detach():Void
  {
    container = null;
    deactivate();
    // end detach
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void
  {
    var curr:DoubleLinkedListHandle<ComponentHandle> = components.head;
    var next:DoubleLinkedListHandle<ComponentHandle>;
    while (curr != null) {
      next = curr.next;
      curr.item.component.activate();
      curr = next;
    }

    active = true;

    // end activate
  }

  public function deactivate():Void
  {
    active = false;

    var curr:DoubleLinkedListHandle<ComponentHandle> = components.head;
    var next:DoubleLinkedListHandle<ComponentHandle>;
    while (curr != null) {
      next = curr.next;
      curr.item.component.deactivate();
      curr = next;
    }

    // end deactivate
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function update(elapsed:Int):Void
  {

    if (!active)
      return;

    //-- Update all entities

    // This loop is laid out explicitly so an iterator isn't created

    var curr:DoubleLinkedListHandle<ComponentHandle> = components.head;
    var next:DoubleLinkedListHandle<ComponentHandle>;
    while (curr != null) {
      next = curr.next; // Cache this in case curr gets removed but it
                        // also means new entities created by the last
                        // entity won't be processed this update...

      curr.item.component.update(elapsed);
      curr = next;
    }

    // end update
  }


  //--------------------------------------------------------------------
  //------------------------------------------------------------
  public static function hashID(id:String):CapabilityID
  {
    return Jenkins.hash32(id);
    // end hashID
  }

  public static function reverseID(id:CapabilityID):String
  {
    return Jenkins.reverse32(id);
    // end reverseID
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function add(component:Component):ComponentHandle
  {
    var containerHandle = new ComponentHandle(this, component);

    var listHandle = components.add(containerHandle);
    containerHandle.listHandle = listHandle;

    component.attach(containerHandle);

    return containerHandle;
    // end add
  }

  public function insert(component:Component):ComponentHandle
  {
    var containerHandle = new ComponentHandle(this, component);

    var listHandle = components.insert(containerHandle);
    containerHandle.listHandle = listHandle;

    component.attach(containerHandle);

    return containerHandle;
    // end add
  }

  public function remove(handle:ComponentHandle):Void
  {
    components.remove(handle.listHandle);
    handle.component.detach();
    // end remove
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function claim(capability:CapabilityID,
                        component:ComponentHandle):Void
  {
    #if verbose_cmp
      trace("Claim " + capability);
    #end
    capabilities.set(capability, component);
    // end claim
  }

  public function release(capability:CapabilityID,
                          component:ComponentHandle):Void
  {
    #if verbose_cmp
      trace("Release " + capability);
    #end

    if (capabilities.get(capability) == component)
      capabilities.remove(capability);
    // end release
  }

  public function find(capability:CapabilityID,
                       necessary:Bool=true):Component
  {
    var x = capabilities.get(capability);

    if (x != null)
      return x.component;

    if (necessary)
      reportMissing(capability);

    return null;
    // end find
  }

  public function findHandle(capability:CapabilityID,
                             necessary:Bool=true):ComponentHandle
  {
    var res = capabilities.get(capability);

    if (necessary && res == null)
      reportMissing(capability);

    return res;
    // end findCapabilityHandle
  }

  private function reportMissing(capability:CapabilityID):Void
  {
    var s:StringBuf = new StringBuf();
    s.add("Available: ");
    for (k in capabilities.keys()) {
      s.add(reverseID(k));
      s.add(" ");
    }

    Debug.error("Capability " + reverseID(capability) +
                " (" + capability + ") not found.");
    Debug.error(s.toString());
      // end reportMissingCapability
  }


  //----------------------------------------------------
  public function claimByID(capability:String,
                            component:ComponentHandle):Void
  {
    claim(hashID(capability), component);
  }

  public function releaseByID(capability:String,
                              component:ComponentHandle):Void
  {
    release(hashID(capability), component);
  }

  public function findByID(capability:String,
                           necessary:Bool=true):Component
  {
    return find(hashID(capability), necessary);
  }

  public function findHandleByID(capability:String,
                                 necessary:Bool=true):ComponentHandle
  {
    return findHandle(hashID(capability), necessary);
  }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function iterator():DoubleLinkedListIterator<ComponentHandle>
  {
    return components.iterator();
  }

  // end ComponentContainer
}
