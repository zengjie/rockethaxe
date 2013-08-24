package com.rocketshipgames.haxe.ds;

class Deadpool<T: (DeadpoolObject)>
{

  //------------------------------------------------------------
  private var totalList:List<T>;
  private var freeList:List<T>;
  private var instantiate:Dynamic->T;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(instantiate:Dynamic->T):Void
  {
    this.instantiate = instantiate;
    totalList = new List();
    freeList = new List();
    // end new
  }

  public function hasFree():Bool { return freeList.isEmpty(); }

  public function lengthAll():Int { return totalList.length; }
  public function iteratorAll():Iterator<T> { return totalList.iterator(); }


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function newObject(opts:Dynamic = null):T
  {
    var object:T;

    if (freeList.isEmpty()) {
      object = instantiate(opts);
      object.setDeadpool(this);
      totalList.push(object);
    } else {
      object = freeList.pop();
      object.init(opts);
    }

    return object;
    // end newObject
  }

  public function returnObject(object:T):Void
  {
    // Note that in general for very large sets it makes sense to
    // reuse the most recently used object, so it's still in cache.
    freeList.push(object);
    // end returnObject
  }

  // end Deadpool
}
