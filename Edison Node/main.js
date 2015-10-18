// BLUETOOTH!

var bleno = require('bleno'),
  BodyCompositionService = require('./body-composition-service');
  
var primaryService = new BodyCompositionService();


//bleno.startAdvertising('BlueTape', [primaryService.uuid]);

bleno.on('stateChange', function(state) {
    console.log('on -> stateChange: ' + state);

    if (state === 'poweredOn') {
        bleno.startAdvertising('BlueTape', [primaryService.uuid]);
    } else {
        bleno.stopAdvertising();
    }
});

bleno.on('advertisingStart', function(error) {
    console.log('on -> advertisingStart: ' + (error ? 'error ' + error : 'success'));

    if (!error) {
        bleno.setServices([primaryService]);
    }
});


// FILE READ LOOP!

// var fs = require('fs');
// var readStream = fs.createReadStream('/tmp/measurement.txt');
// readStream.pipe(process.stdout);
