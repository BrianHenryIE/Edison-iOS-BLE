var util = require('util'),
  os = require('os'),
  exec = require('child_process').exec,
  bleno = require('bleno'),
  Descriptor = bleno.Descriptor,
  Characteristic = bleno.Characteristic;

var WaistCircumferenceCharacteristic = function() {
  WaistCircumferenceCharacteristic.super_.call(this, {
      uuid: '2A97',
      properties: ['read'] //,
//      descriptors: [
//        new Descriptor({
//            uuid: '2901',
//            value: 'Battery level between 0 and 100 percent'
//        }),
//        new Descriptor({
//            uuid: '2904',
//            value: new Buffer([0x04, 0x01, 0x27, 0xAD, 0x01, 0x00, 0x00 ]) // maybe 12 0xC unsigned 8 bit
//        })
//      ]
  });
};

util.inherits(WaistCircumferenceCharacteristic, Characteristic);

WaistCircumferenceCharacteristic.prototype.onReadRequest = function(offset, callback) {
    
    // return a value that is this minute and seconds e.g. 23:44
  var timeNow = new Date();
  var valueString = "" + timeNow.getMinutes() + "." + timeNow.getSeconds();
    
    callback(this.RESULT_SUCCESS, new Buffer(valueString));
    // callback(this.RESULT_SUCCESS, new Buffer([98]));
  
};




module.exports = WaistCircumferenceCharacteristic;