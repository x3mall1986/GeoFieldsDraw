//
//  GFDFieldsListTableViewCell.h
//  GeoFieldsDraw
//
//  Created by Dmytro Shevchuk on 05.07.16.
//  Copyright © 2016 PaksUkroInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFDFieldsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropLabel;
@property (weak, nonatomic) IBOutlet UILabel *tillAreaLabel;

@end