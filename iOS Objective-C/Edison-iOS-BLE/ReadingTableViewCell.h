//
//  ReadingTableViewCell.h
//  Edison-iOS-BLE
//
//  Created by Brian Henry on 10/06/2015.
//  Copyright (c) 2015 Brian Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *peripheralLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *characteristicLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end
