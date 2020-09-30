using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.System;
using Toybox.Lang;

class LapPaceDemoView extends WatchUi.SimpleDataField {
  var lastLapTime = 0;
  var lastLapDistance = 0;
  var lapStartTime = 0;
  var lapStartDistance = 0;
  var showLastLapTime = 0;

  function initialize() {
    SimpleDataField.initialize();
    label = "Lap Pace";
  }

  function onTimerLap() {
    var info = Activity.getActivityInfo();
    if (info.elapsedDistance == lapStartTime ||
        info.elapsedDistance == lapStartDistance) {
      // Too quick, ignore lap;
      return;
    }
    lastLapTime = info.elapsedTime - lapStartTime;
    lastLapDistance = info.elapsedDistance - lapStartDistance;
    lapStartTime = info.elapsedTime;
    lapStartDistance = info.elapsedDistance;
    showLastLapTime = System.getTimer() + 4000;
    WatchUi.requestUpdate();
  }

  function pace100m(pace) {
    // pace in ms / m, convert to seconds per 100m
    var sec100m = (pace / 10).toNumber();
    var minutes = Math.floor(sec100m / 60);
    var seconds = sec100m % 60;
    return Lang.format("$1$:$2$", [ minutes, seconds.format("%02d") ]);
  }

  function compute(info) {
  	if (info.elapsedDistance == null) {
  	  return "...";
  	}
    if (System.getTimer() < showLastLapTime) {
      // Show last lap pace
      return "Last " + pace100m(lastLapTime / lastLapDistance);
    }
    // Show current lap pace
    var lapTime = info.elapsedTime - lapStartTime;
    var lapDistance = info.elapsedDistance - lapStartDistance;
    return "Current " + pace100m(lapTime / lapDistance);
  }
}