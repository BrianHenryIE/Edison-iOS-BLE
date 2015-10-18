var util = require('util'),
  bleno = require('bleno'),
  BlenoPrimaryService = bleno.PrimaryService,
  WaistCircumferenceCharacteristic = require('./waist-circumference-characteristic'),
  NotifyOnlyCharacteristic = require('./notify-only-characteristic');



function BodyCompositionService() {
  BodyCompositionService.super_.call(this, {
      uuid: '181B',
      characteristics: [
          new NotifyOnlyCharacteristic()
      ]
  });
} //  new WaistCircumferenceCharacteristic(),

util.inherits(BodyCompositionService, BlenoPrimaryService);

module.exports = BodyCompositionService;