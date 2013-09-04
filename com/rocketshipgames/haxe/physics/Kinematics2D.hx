package com.rocketshipgames.haxe.physics;


interface Kinematics2D
{

  var x:Float;
  var y:Float;

  var xvel:Float;
  var xacc:Float;
  var xdrag:Float;

  var yvel:Float;
  var yacc:Float;
  var ydrag:Float;

  var xvelMin:Float;
  var xvelMax:Float;

  var yvelMin:Float;
  var yvelMax:Float;

}
