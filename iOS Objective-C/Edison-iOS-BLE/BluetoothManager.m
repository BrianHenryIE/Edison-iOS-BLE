//
//  BluetoothManager.m
//  Edison-iOS-BLE
//
//  Created by Brian Henry on 10/06/2015.
//  Copyright (c) 2015 Brian Henry. All rights reserved.
//

#import "BluetoothManager.h"

@interface BluetoothManager()

@property (strong, nonatomic) NSArray *services;

@end

@implementation BluetoothManager

// Singleton
+ (BluetoothManager*)sharedInstance
{
    // 1
    static BluetoothManager *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[BluetoothManager alloc] init];
    });
    return _sharedInstance;
}


-(id) init
{
    self = [super init];
    if( self ) {
        
        // Scan for available CoreBluetooth LE devices
        //    NSArray *services = @[[CBUUID UUIDWithString:BODY_COMPOSITION_SERVICE_UUID], [CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]];
        CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        //    [centralManager scanForPeripheralsWithServices:services options:nil];
        
        self.centralManager = centralManager;
        
        // We'll only be searching for this for now.
        _services = nil; // @[[CBUUID UUIDWithString:BODY_COMPOSITION_SERVICE_UUID]];
        
    }
    return self;
}


-(void)search
{
    NSLog(@"Start search (from method)");
    [self.centralManager scanForPeripheralsWithServices:_services options:nil];
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
    NSString *connected;
    connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", connected);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found: %@", localName);
        [self.centralManager stopScan];
        self.bluetapePeripheral = peripheral;
        peripheral.delegate = self;
        // option is key to background receiving of data.
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        
        NSLog(@"Start search (from centralManagerDidUpdateState)");
        [self.centralManager scanForPeripheralsWithServices:_services options:nil];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}


#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices count:%lu", (unsigned long)peripheral.services.count);
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    // Notify
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:service.characteristics forKey:@"characteristics"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Service Characteristics" object:nil userInfo:dictionary];

    
    for (CBCharacteristic *aChar in service.characteristics)
    {
        NSLog(@"Characteristic: %@", aChar.UUID);
        
        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:WAIST_CIRCUMFERENCE_CHARACTERISTIC_UUID]]) {
//            [self.bluetapePeripheral readValueForCharacteristic:aChar];
//            NSLog(@"Found waist circumference measurement characteristic");
            [self.bluetapePeripheral setNotifyValue:YES forCharacteristic:aChar];
            NSLog(@"Subscribed to Waist Circumference...");
        } else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"062E666B-231D-4CB3-81A1-8F15240E1DE9"]]) {
            [self.bluetapePeripheral setNotifyValue:YES forCharacteristic:aChar];
            NSLog(@"Found notify-only-characteristic");
        }
    }
    
    // Retrieve Device Information Services for the Manufacturer Name
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]])  { // 4
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {
                [self.bluetapePeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    // Notify
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:characteristic forKey:@"characteristic"];
    [dictionary setObject:[NSDate date] forKey:@"timestamp"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Characteristic Data Reading" object:nil userInfo:dictionary];
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WAIST_CIRCUMFERENCE_CHARACTERISTIC_UUID]]) {
        NSString *waistMeasurement = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Waist Measurement: %@", waistMeasurement);
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"062E666B-231D-4CB3-81A1-8F15240E1DE9"]]) {
        NSString *notifyData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Data sent from device: %@", notifyData);
    }
    
    
    // Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {
        NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Manufacturer: %@", manufacturerName);
    }
    
}


@end
