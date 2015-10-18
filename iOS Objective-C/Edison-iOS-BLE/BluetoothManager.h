//
//  BluetoothManager.h
//  Edison-iOS-BLE
//
//  Created by Brian Henry on 10/06/2015.
//  Copyright (c) 2015 Brian Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

#define DEVICE_INFO_SERVICE_UUID @"180A" // Device Information

#define BODY_COMPOSITION_SERVICE_UUID @"181B" // Body Composition

#define MANUFACTURER_NAME_CHARACTERISTIC_UUID @"2A29" // Manufacturer

#define WAIST_CIRCUMFERENCE_CHARACTERISTIC_UUID @"2A97" // Waist Circumference


@interface BluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *bluetapePeripheral;

+ (BluetoothManager*)sharedInstance;
- (void)search;

@end