//
//  BluetoothViewController.h
//  Edison-iOS-BLE
//
//  Created by Brian Henry on 23/05/2015.
//  Copyright (c) 2015 Brian Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *deviceTableView;
@property (strong, nonatomic) IBOutlet UITableView *readingsTableView;


@end
