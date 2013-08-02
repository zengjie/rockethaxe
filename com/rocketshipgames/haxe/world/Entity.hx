package com.rocketshipgames.haxe.world;

interface Entity {

  var nextEntity:Entity;
  var prevEntity:Entity;

  function update(elapsed:Int):Void;

  // end Entity
}
