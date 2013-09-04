package com.rocketshipgames.haxe.component;


interface State {

  // The id is passed to these two functions so a single object can
  // manage multiple states.

  function getValue(id:StateID):Dynamic;
  function remove(id:StateID):Void;

  // end State
}
