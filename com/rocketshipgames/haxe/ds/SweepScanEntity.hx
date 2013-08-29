package com.rocketshipgames.haxe.ds;


interface SweepScanEntity
{

  function top():Float;
  function bottom():Float;

  function collidesAs():Int;
  function collidesWith():Int;

  // end 
}
