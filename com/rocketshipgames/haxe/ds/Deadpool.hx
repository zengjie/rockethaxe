package com.rocketshipgames.haxe.ds;

class Deadpool<T: (DeadpoolObject)>
{

  //------------------------------------------------------------
  private var deadpool:MementoMori<T>;
  private var memos:MementoMori<T>;

  //  private var totalList:List<T>;
  private var instantiate:Dynamic->T;


  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function new(instantiate:Dynamic->T):Void
  {
    this.instantiate = instantiate;
    deadpool = memos = null;
    // end new
  }

  public function hasFree():Bool { return deadpool!=null; }

  //--------------------------------------------------------------------
  //----------------------------------------------------
  public function newObject(opts:Dynamic = null):T
  {
    var object:T;

    if (deadpool==null) {
      object = instantiate(opts);
      object.setDeadpool(this);
    } else {
      var m = deadpool;

      deadpool = m.next;

      m.next = memos;
      memos = m;

      object = m.object;
      object.init(opts);
    }

    return object;
    // end newObject
  }


  //----------------------------------------------------
  public function returnObject(object:T):Void
  {
    // Note that in general for very large sets it makes sense to
    // reuse the most recently used object, so it's still in cache.
    var m:MementoMori<T>;

    if (memos == null)
      m = new MementoMori();
    else {
      m = memos;
      memos = memos.next;
    }

    m.object = object;
    m.next = deadpool;
    deadpool = m;

    // end returnObject
  }

  // end Deadpool
}


private class MementoMori<T>
{

  public var object:T;
  public var next:MementoMori<T>;

  public function new():Void
  {
    #if verbose_ds
      trace("New MementoMori");
    #end
  }

  // end MementoMori
}
