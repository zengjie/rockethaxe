package com.rocketshipgames.haxe.component;


class EmptyComponent
  implements Component
{

  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function new():Void {}

  //----------------------------------------------------
  public function activate(?opts:Dynamic):Void {}
  public function deactivate():Void {}

  //----------------------------------------------------
  public function attach(container:ComponentHandle):Void {}
  public function detach():Void {}


  //--------------------------------------------------------------------
  //--------------------------------------------------------------------
  public function update(elapsed:Int):Void {}

  // end EmptyComponent
}
