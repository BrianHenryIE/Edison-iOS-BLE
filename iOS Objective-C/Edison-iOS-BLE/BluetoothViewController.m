//
//  BluetoothViewController.m
//  Edison-iOS-BLE
//
//  Created by Brian Henry on 23/05/2015.
//  Copyright (c) 2015 Brian Henry. All rights reserved.
//

#import "BluetoothViewController.h"
#import "BluetoothManager.h"
#import "DeviceTableViewCell.h"
#import "ReadingTableViewCell.h"
@import CoreBluetooth;

@interface BluetoothViewController ()


@property (strong, nonatomic) NSMutableArray *discoveredCharacteristics;
@property (strong, nonatomic) NSMutableArray *readings;

@property (strong, nonatomic) BluetoothManager *btm;


- (IBAction)searchButton:(id)sender;


@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _btm = [BluetoothManager sharedInstance];
    
    _discoveredCharacteristics = [[NSMutableArray alloc] init];
    _readings = [[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedCharacteristics:)
                                                 name:@"Service Characteristics"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData:)
                                                 name:@"Characteristic Data Reading"
                                               object:nil];
    
    [_btm search];
}


- (void)receivedCharacteristics:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Service Characteristics"]) {
        
        NSArray *characteristics = [[notification userInfo] valueForKey:@"characteristics"];
        
        [_discoveredCharacteristics addObjectsFromArray:characteristics];
        
        NSLog(@"Notification: characteristics found: %ld", (long)characteristics.count);
        
        [self.deviceTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
}



- (void)receivedData:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Characteristic Data Reading"]) {
        
        // update table
        [_readings insertObject:[notification userInfo] atIndex:0];
        [self.readingsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchButton:(id)sender {

    [_discoveredCharacteristics removeAllObjects];
    
    [self.deviceTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [_btm search];

}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger count = 0;
    
    if(tableView == self.deviceTableView){
        
        count = _discoveredCharacteristics.count;
       
    }
    
    if(tableView == self.readingsTableView){
    
        count = _readings.count;
    }
 
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView == self.deviceTableView){
        
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
        
        CBCharacteristic *characteristic = _discoveredCharacteristics[indexPath.row];
        
        [cell.peripheralLabel setText:characteristic.service.peripheral.name];
        [cell.serviceLabel setText:characteristic.service.UUID.UUIDString];
        [cell.characteristicLabel setText:characteristic.UUID.UUIDString];
        
        // TODO
        [cell.subscribedLabel setText:@""];
        
        return cell;
    }
    
    if(tableView == self.readingsTableView){
        
        ReadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readingCell" forIndexPath:indexPath];
        
        NSDictionary *reading = _readings[indexPath.row];
        CBCharacteristic *characteristic = [reading valueForKey:@"characteristic"];
        
        [cell.peripheralLabel setText:[[[characteristic service] peripheral] name]];
        
        NSDate *date = [reading valueForKey:@"timestamp"];
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"hh:mm:ss"];
        NSString *time = [DateFormatter stringFromDate:date];
        [cell.timeLabel setText:time];
     
        [cell.valueLabel setText:[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]];
        
        [cell.serviceLabel setText:characteristic.service.UUID.UUIDString];
        [cell.characteristicLabel setText:characteristic.UUID.UUIDString];
        
        
        //        [characteristic descriptors]
        // [characteristic description]
        //        [characteristic properties]
        
        
        return cell;
    }
    
    // Should never be reached!
    // Maybe there's a generic cell we should return here
    return nil;
 
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    
    if(tableView == self.deviceTableView){

        // Subscribe/unsubscribe/display value
        
        CBCharacteristic *characteristic = _discoveredCharacteristics[indexPath.row];
    
        

        
    }
    
    
}


@end
