//var util = require('util');
//
//var bleno = require('bleno');
//
//var BlenoPrimaryService = bleno.PrimaryService;
//var BlenoCharacteristic = bleno.Characteristic;
//var BlenoDescriptor = bleno.Descriptor;

var util = require('util'),
  os = require('os'),
  exec = require('child_process').exec,
  bleno = require('bleno'),
  Descriptor = bleno.Descriptor,
  Characteristic = bleno.Characteristic;

//console.log('Configuring notify-only-characteristic');

var NotifyOnlyCharacteristic = function() {
  NotifyOnlyCharacteristic.super_.call(this, {
    uuid: '062E666B231D4CB381A18F15240E1DE9',
    properties: ['notify']
  });
};

// util.inherits(NotifyOnlyCharacteristic, BlenoCharacteristic);
util.inherits(NotifyOnlyCharacteristic, Characteristic);

NotifyOnlyCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
  console.log('NotifyOnlyCharacteristic subscribe');

  this.counter = 0;
  this.changeInterval = setInterval(function() {
      // This is where the data is determined. In this case it's just a counter.
//    var data = new Buffer(4);
//    data.writeUInt32LE(this.counter, 0);
//
//    console.log('NotifyOnlyCharacteristic update value: ' + this.counter);
//    updateValueCallback(data);
//    this.counter++;
      
        var timeNow = new Date();
  var valueString = "" + timeNow.getMinutes() + "." + timeNow.getSeconds();
    
    updateValueCallback(new Buffer(valueString));
      console.log('NotifyOnlyCharacteristic update value ' + this.counter + ': ' + this.valueString);
      this.counter++;
  }.bind(this), 5000);
};

NotifyOnlyCharacteristic.prototype.onUnsubscribe = function() {
  console.log('NotifyOnlyCharacteristic unsubscribe');

  if (this.changeInterval) {
    clearInterval(this.changeInterval);
    this.changeInterval = null;
  }
};

NotifyOnlyCharacteristic.prototype.onNotify = function() {
  console.log('NotifyOnlyCharacteristic on notify');
};



module.exports = NotifyOnlyCharacteristic;